# Generalized Makefile for Flutter Projects

# Configuration Section
# =====================
# Modify these variables according to your project setup

# Diawi token (get your token from https://dashboard.diawi.com/profile/api)
TOKEN ?= YOUR_DIAWI_TOKEN_HERE

# Paths for APK and IPA files
APK_DEST ?= /path/to/your/apk/directory
IPA_DIR ?= /path/to/your/ipa/directory

# End of Configuration Section

# Do not modify below this line unless you know what you're doing
# ================================================================

.DEFAULT_GOAL := help

# Utility variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Color definitions
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;36m
MAGENTA := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[1;37m
BOLD := \033[1m
NC := \033[0m # No Color

# APP_NAME and DIR_NAME variables
APP_NAME := $(shell grep -o 'name: .*' pubspec.yaml | awk '{print $$2}')
DIR_NAME := $(shell echo "$(APP_NAME)" | sed 's/\b\(.\)/\u\1/g' | sed 's/[^A-Za-z0-9]+/_/g')

# Find latest APK and IPA files
LATEST_APK := $(shell ls -t "$(APK_DEST)"/*.apk 2>/dev/null | head -n1)
LATEST_IPA := $(shell ls -t "$(IPA_DIR)"/*.ipa 2>/dev/null | head -n1)

# FVM and Flutter command setup
FVM_EXISTS := $(shell [ -d ".fvm" ] && echo true || echo false)
FVM_CMD := $(if $(filter true,$(FVM_EXISTS)),fvm flutter,flutter)

# Phony targets
.PHONY: help build-apk upload-apk upload-ipa check-gitignore check_file_apk check_file_ipa get_url

# Display usage information
help:
	@echo -e "\n${BLUE}${BOLD}📱 Flutter Project Makefile${NC}"
	@echo -e "\n${CYAN}Usage:${NC} make ${YELLOW}[target]${NC}"
	@echo -e "\n${CYAN}Available targets:${NC}"
	@echo -e "  ${GREEN}build-apk${NC}   : Build APK file and save it to $(APK_DEST) directory"
	@echo -e "  ${GREEN}upload-apk${NC}  : Upload the latest APK file from $(APK_DEST) to Diawi"
	@echo -e "  ${GREEN}upload-ipa${NC}  : Upload the latest IPA file from $(IPA_DIR) to Diawi"
	@echo -e "  ${GREEN}help${NC}        : Display this help message"
	@echo -e "\n${MAGENTA}Happy coding! 🚀${NC}\n"

# Progress bar function
define progress_bar
	@i=0; \
	while [ $$i -le 50 ]; do \
		printf "\r[%-50s] %d%%" "$$(printf '%0.s=' $$(seq 1 $$i))" "$$(($$i * 2))"; \
		sleep 0.1; \
		i=$$((i + 1)); \
	done; \
	printf "\r[%-50s] %d%%\n" "$$(printf '%0.s=' $$(seq 1 50))" "100"
endef

# Build APK
build-apk: check-gitignore
	@if [ -z "$(APK_DEST)" ]; then \
		echo -e "\n${RED}[ERROR]${NC} APK_DEST is not set. Please update the APK_DEST path in the Makefile."; \
		exit 1; \
	fi

	@if [ -f "pubspec.yaml" ]; then \
		echo -e "\n${CYAN}${BOLD}🔨 Building APK${NC}\n"; \
		echo -e "${GREEN}[1/4]${NC} Cleaning project..."; \
		$(FVM_CMD) clean; \
		echo -e "\n${GREEN}[2/4]${NC} Getting dependencies..."; \
		$(FVM_CMD) pub get; \
		if [ -d "lib/l10n" ]; then \
			echo -e "\n${GREEN}[3/4]${NC} Generating localizations..."; \
			$(FVM_CMD) gen-l10n; \
		fi; \
		echo -e "\n${GREEN}[4/4]${NC} Building APK..."; \
		$(FVM_CMD) build apk; \
		if [ $$? -eq 0 ]; then \
			dest_dir="$(APK_DEST)"; \
			if [ ! -d "$$dest_dir" ]; then \
				mkdir -p "$$dest_dir"; \
				echo -e "${YELLOW}[INFO]${NC} Created directory: $$dest_dir"; \
			fi; \
			apk_name="$(DIR_NAME) - $$(date +'%Y-%m-%d-%I-%M-%S-%p').apk"; \
			mv build/app/outputs/flutter-apk/app-release.apk "$$dest_dir/$$apk_name"; \
			if [ $$? -eq 0 ]; then \
				echo -e "\n${GREEN}${BOLD}✅ APK built successfully!${NC}"; \
				echo -e "${CYAN}Location:${NC} $$dest_dir/$$apk_name\n"; \
			else \
				echo -e "\n${RED}${BOLD}❌ Failed to move the APK file to the destination directory.${NC}\n"; \
			fi; \
		else \
			echo -e "\n${RED}${BOLD}❌ Failed to build APK. Please check your Flutter configuration.${NC}\n"; \
		fi; \
	else \
		echo -e "\n${RED}${BOLD}❌ Error: This command should be run from a Flutter project directory.${NC}\n"; \
	fi

# Upload APK to Diawi
upload-apk: check_file_apk
	@if [ -z "$(TOKEN)" ]; then \
		echo -e "\n${RED}[ERROR]${NC} TOKEN is not set. Please update the TOKEN in the Makefile."; \
		exit 1; \
	fi
	@echo -e "\n${CYAN}${BOLD}📤 Uploading APK to Diawi${NC}"
	@echo -e "${YELLOW}File:${NC} $(LATEST_APK)"
	@echo -e "\n${GREEN}Uploading...${NC}"
	@$(call progress_bar) & \
	UPLOAD_RESULT=$$(curl -s -F token=$(TOKEN) \
		-F file=@"$(LATEST_APK)" \
		-F find_by_udid=false \
		-F wall_of_apps=false \
		https://upload.diawi.com/); \
	wait; \
	JOB_ID=$$(echo $$UPLOAD_RESULT | jq -r '.job'); \
	if [ -z "$$JOB_ID" ]; then \
		echo -e "\n${RED}${BOLD}❌ Upload failed. Please check the file and try again.${NC}\n"; \
	else \
		echo -e "\n${GREEN}${BOLD}✅ APK uploaded successfully!${NC}"; \
		echo -e "${CYAN}Job ID:${NC} $$JOB_ID\n"; \
		$(MAKE) -s get_url job=$$JOB_ID; \
	fi

# Upload IPA to Diawi
upload-ipa: check_file_ipa
	@if [ -z "$(TOKEN)" ]; then \
		echo -e "${RED}[ERROR]${NC} TOKEN is not set. Please update the TOKEN in the Makefile."; \
		exit 1; \
	fi
	@echo -e "\n${CYAN}${BOLD}📤 Uploading IPA to Diawi${NC}"
	@echo -e "${YELLOW}File:${NC} $(LATEST_IPA)\n"
	@echo -e "${GREEN}Uploading...${NC}"
	@$(call progress_bar) & \
	UPLOAD_RESULT=$$(curl -s -F token=$(TOKEN) \
		-F file=@"$(LATEST_IPA)" \
		-F find_by_udid=false \
		-F wall_of_apps=false \
		https://upload.diawi.com/); \
	wait; \
	JOB_ID=$$(echo $$UPLOAD_RESULT | jq -r '.job'); \
	if [ -z "$$JOB_ID" ]; then \
		echo -e "\n${RED}${BOLD}❌ Upload failed. Please check the file and try again.${NC}\n"; \
	else \
		echo -e "\n${GREEN}${BOLD}✅ IPA uploaded successfully!${NC}"; \
		echo -e "${CYAN}Job ID:${NC} $$JOB_ID\n"; \
		$(MAKE) -s get_url job=$$JOB_ID; \
	fi

# Get Diawi URL
get_url:
	@echo -e "${CYAN}Generating Diawi URL...${NC}"
	@$(call progress_bar) & \
	sleep 5; \
	wait; \
	DIAWI_URL=$$(curl -s "https://upload.diawi.com/status?token=$(TOKEN)&job=$(job)" | jq -r '.link'); \
	if [ -z "$$DIAWI_URL" ] || [ "$$DIAWI_URL" = "null" ]; then \
		echo -e "\n${RED}${BOLD}❌ Failed to generate Diawi URL. Please check your job ID and try again.${NC}\n"; \
	else \
		echo -e "\n${GREEN}${BOLD}🔗 Diawi URL:${NC} $$DIAWI_URL\n"; \
	fi

# Check APK file existence
check_file_apk:
	@if [ -z "$(APK_DEST)" ]; then \
		echo -e "\n${RED}${BOLD}❌ Error: APK_DEST is not set. Please update the APK_DEST path in the Makefile.${NC}\n"; \
		exit 1; \
	fi
	@if [ -z "$(LATEST_APK)" ]; then \
		echo -e "\n${RED}${BOLD}❌ Error: APK file not found in directory: $(APK_DEST)${NC}\n"; \
		exit 1; \
	fi

# Check IPA file existence
check_file_ipa:
	@if [ -z "$(IPA_DIR)" ]; then \
		echo -e "\n${RED}${BOLD}❌ Error: IPA_DIR is not set. Please update the IPA_DIR path in the Makefile.${NC}\n"; \
		exit 1; \
	fi
	@if [ -z "$(LATEST_IPA)" ]; then \
		echo -e "\n${RED}${BOLD}❌ Error: IPA file not found in directory: $(IPA_DIR)${NC}\n"; \
		exit 1; \
	fi

# Check and update .gitignore
check-gitignore:
	@if [ ! -f ".gitignore" ]; then \
		echo "Makefile" > .gitignore; \
		echo -e "${YELLOW}[INFO]${NC} Created .gitignore and added Makefile to it."; \
	elif ! grep -q "^Makefile$$" .gitignore; then \
		echo "Makefile" >> .gitignore; \
		echo -e "${YELLOW}[INFO]${NC} Added Makefile to .gitignore."; \
	fi