import 'package:flash_note/screens/auth/notes/bloc/notes_bloc.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<Notes> {
  final NotesBloc _bloc = NotesBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
