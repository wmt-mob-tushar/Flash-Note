import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/auth/notes_details/bloc/notes_details_bloc.dart';
import 'package:flash_note/utils/constants.dart';
import 'package:flash_note/widgets/ui/commonBackground.dart';
import 'package:flash_note/widgets/ui/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotesDetails extends StatefulWidget {
  const NotesDetails({super.key});

  @override
  State<NotesDetails> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetails> {
  final NotesDetailsBloc _bloc = NotesDetailsBloc();
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppbar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              l10n?.done ?? "Done",
            ),
          ),
        ],
      ),
      backgroundColor: ResColors.white,
      body: CommonBackground(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuillEditor(
                  controller: _controller,
                  scrollController: ScrollController(),
                  configurations: const QuillEditorConfigurations(
                    autoFocus: true,
                    placeholder: 'Start typing...',
                  ),
                  focusNode: _focusNode,
                ),
              ),
            ),
            QuillToolbar.simple(
              controller: _controller,
              configurations: QuillSimpleToolbarConfigurations(
                multiRowsDisplay: false,
                decoration: BoxDecoration(
                  color: ResColors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
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
