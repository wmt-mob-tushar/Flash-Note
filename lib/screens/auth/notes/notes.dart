import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/auth/notes/bloc/notes_bloc.dart';
import 'package:flash_note/utils/routes.dart';
import 'package:flash_note/widgets/ui/commonBackground.dart';
import 'package:flash_note/widgets/ui/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Note {
  final String type;
  final String title;
  final String content;
  final String? date;
  final Color? color;
  final List<TodoItem>? todoItems;

  Note({
    required this.type,
    required this.title,
    required this.content,
    this.date,
    this.color,
    this.todoItems,
  });
}

class TodoItem {
  final String text;
  bool isDone;

  TodoItem({required this.text, this.isDone = false});
}

class Notes extends StatefulWidget {
  final String foldersId;

  const Notes({super.key, required this.foldersId});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final NotesBloc _bloc = NotesBloc();

  // Sample data
  final List<Note> notes = [
    Note(
      type: 'markdown',
      title: "Today's Quote",
      content: '> "Keep your face to the sunshine and you cannot see a shadow."',
      date: 'DEC 05/23',
      color: Color(0xFFFFF8E1),
    ),
    Note(
      type: 'markdown',
      title: 'Buying List',
      content: '''
- [x] Bread 🍞
      ''',
      color: Color(0xFFE1F5FE),
    ),
    Note(
      type: 'markdown',
      title: 'Books',
      content: '''
- Glory
- Getting Lost
- To Paradise
- Vladimir
      ''',
      date: 'DEC 05/23',
      color: Color(0xFFF1F8E9),
    ),
    Note(
      type: 'todo',
      title: 'To-Do List',
      content: 'Things to be done by today:',
      todoItems: [
        TodoItem(text: 'Checkup'),
        TodoItem(text: 'Android'),
        TodoItem(text: 'Email Client'),
      ],
      date: 'Mon 11/45',
      color: Color(0xFFFCE4EC),
    ),
    Note(
      type: 'markdown',
      title: 'UI Design',
      content: '''
The user interface (UI) is the space where interactions between humans and machines occur.

[New Read](#)
      ''',
      date: 'TUE 06/11',
      color: Color(0xFFE8EAF6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bloc.fetchNotes(widget.foldersId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      backgroundColor: ResColors.white,
      body: CommonBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _header(),
              SizedBox(height: 12.h),
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.w,
                  crossAxisSpacing: 10.w,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(notes[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: note.color ?? Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          if (note.type == 'markdown')
            MarkdownBody(
              data: note.content,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: 14.sp),
                checkbox: TextStyle(fontSize: 14.sp),
              ),
            )
          else if (note.type == 'todo')
            _buildTodoList(note),
          if (note.date != null) ...[
            SizedBox(height: 8.h),
            Text(
              note.date!,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodoList(Note note) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.content,
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        ...note.todoItems!.map((item) => Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Checkbox(
                value: item.isDone,
                onChanged: (value) {
                  setState(() {
                    item.isDone = value ?? false;
                  });
                },
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              item.text,
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        )).toList(),
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: () {},
          child: Text('Today'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(60.w, 30.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
          ),
        ),
      ],
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
              context.l10n?.personalNotes ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  "12 ${context.l10n?.notes ?? ""}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ResColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.noteDetailsRoute),
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}