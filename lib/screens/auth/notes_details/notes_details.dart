import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/auth/notes_details/bloc/notes_details_bloc.dart';
import 'package:flash_note/utils/constants.dart';
import 'package:flash_note/utils/custom_quill_style.dart';
import 'package:flash_note/widgets/ui/commonBackground.dart';
import 'package:flash_note/widgets/ui/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markdown_quill/markdown_quill.dart';
import 'package:snug_logger/snug_logger.dart';

class NotesDetails extends StatefulWidget {
  const NotesDetails({super.key});

  @override
  State<NotesDetails> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetails> {
  final NotesDetailsBloc _bloc = NotesDetailsBloc();
  final QuillController _controller = QuillController.basic();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void onDonePressed() {
    final delta = _controller.document.toDelta();
    final markdown = DeltaToMarkdown().convert(delta);
    snugLog(markdown);
  }

  void onDropPressed() {
    FocusScope.of(context).unfocus();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _tagsController.text.isEmpty) {
      _bloc.removeLastTag();
    }
  }

  void _addTag(String value) {
    final tag = value.trim();
    if (tag.isNotEmpty) {
      _bloc.createTag(tag);
      _tagsController.clear();
      _tagFocusNode.requestFocus();
    }
  }

  void _onChangeTags(String value) {
    if (value.endsWith(",") || value.endsWith(" ")) {
      _addTag(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppbar(
        actions: [
          TextButton(
            onPressed: () => onDonePressed(),
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(
                TextStyle(
                  fontSize: 16.sp,
                  color: ResColors.textPrimary,
                ),
              ),
            ),
            child: Text(l10n?.done ?? ""),
          ),
        ],
      ),
      backgroundColor: ResColors.white,
      body: CommonBackground(
        isAnimated: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l10n?.title ?? "",
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              style: TextStyle(
                fontFamily: FontFamily.secondary,
                fontSize: 22.sp,
                color: ResColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            _tagsInputField(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: QuillEditor(
                  controller: _controller,
                  scrollController: ScrollController(),
                  configurations: QuillEditorConfigurations(
                    placeholder: l10n?.startTypingHere ?? "",
                    customStyles: customQuillStyles(),
                  ),
                  focusNode: _focusNode,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ResColors.white,
                    ResColors.textColorDisabled,
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
              child: QuillToolbar.simple(
                controller: _controller,
                configurations: toolbarConfigurations(
                  onDropPressed: onDropPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagsInputField() {
    return StreamBuilder<List<String>>(
      stream: _bloc.multiSelectTags,
      builder: (context, snapshot) {
        final tags = snapshot.data ?? [];

        return Container(
          constraints: BoxConstraints(minHeight: 55.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKeyEvent(event),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tags.isNotEmpty) ...[
                    Icon(
                      Icons.local_offer_outlined,
                      size: 18.sp,
                      color: ResColors.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...tags.map((tag) => _buildTagChip(tag)),
                      SizedBox(
                        width: 120.w,
                        child: TextField(
                          controller: _tagsController,
                          focusNode: _tagFocusNode,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ResColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: tags.isEmpty
                                ? (context.l10n?.tags ?? "")
                                : (context.l10n?.addMoretags ?? ""),
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: ResColors.textColorDisabled,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) => _onChangeTags(value),
                          onSubmitted: (value) => _addTag(value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      decoration: BoxDecoration(
        color: ResColors.black,
        borderRadius: BorderRadius.circular(6.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(
              fontSize: 14.sp,
              color: ResColors.white,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () => _bloc.removeTag(tag),
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: ResColors.textColorDisabled,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _bloc.dispose();
    super.dispose();
  }
}
