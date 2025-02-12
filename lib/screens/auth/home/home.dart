import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/fetch_folder_data.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/auth/home/bloc/home_bloc.dart';
import 'package:flash_note/utils/common_utils.dart';
import 'package:flash_note/utils/constants.dart';
import 'package:flash_note/utils/routes.dart';
import 'package:flash_note/widgets/ui/commonBackground.dart';
import 'package:flash_note/widgets/ui/commonDialog.dart';
import 'package:flash_note/widgets/ui/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc _bloc = HomeBloc();
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchFolders();
    _bloc.createFolder.listen(createFolderHandler);
  }

  void createFolderHandler(ApiResponse<FetchFolderData> value) {
    if (value.status == Status.COMPLETED) {
      CommonUtils.showToast(context.l10n?.folderCreatedSuccess ?? '');
    } else if (value.status == Status.ERROR) {
      CommonUtils.showToast(value.message ?? '', type: MessageType.FAILED);
    }
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
            onConfirm: onFolderCreated,
            isTextField: true,
            formKey: _formKey,
            inputController: _controller,
            textInputFieldLabel: context.l10n?.enterFolderName ?? "",
            title: context.l10n?.createFolder ?? "",
            confirmButtonText: context.l10n?.addFolder ?? "");
      },
    );
  }

  void onFolderCreated() {
    if (_formKey.currentState!.validate()) {
      _bloc.generateFolder(_controller.text.trim());
      _controller.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppbar(
        hasDrawer: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      backgroundColor: ResColors.background,
      drawer: const Drawer(),
      body: CommonBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Header
              _header(),
              SizedBox(height: 6.h),
              // List of folders
              Expanded(
                child: StreamBuilder<List<FetchFolderData>>(
                  stream: _bloc.folders.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ResColors.black,
                        ),
                      );
                    }

                    if (snapshot.data?.isNotEmpty ?? false) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (item, index) {
                          final item = snapshot.data?[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.notesRoute,
                                arguments: item?.id ?? 0),
                            child: Row(
                              children: [
                                Text(
                                  "${index < 9 ? "0" : ""}${index + 1}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Container(
                                  padding: EdgeInsets.only(top: 15.h),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: ResColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0.8.sw,
                                        child: Text(
                                          item?.folderName ?? "",
                                          style: TextStyle(
                                              fontSize: 32.sp,
                                              fontFamily: FontFamily.secondary,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      SizedBox(height: 7.h),
                                      Text(
                                        "${10} ${l10n?.notes ?? ""}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: ResColors.textPrimary,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          context.l10n?.noFolderFound ?? "",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ResColors.textSecondary,
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n?.allFolder ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  context.l10n?.thisMonth ?? "",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ResColors.textSecondary,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.calendar_month,
                  size: 16.sp,
                  color: ResColors.textSecondary,
                )
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: openDialog,
          child: Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              border: Border.all(
                color: ResColors.textPrimary,
              ),
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: Icon(Icons.add, size: 32.sp),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
