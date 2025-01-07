import 'package:flash_note/screens/auth/notes_details/bloc/notes_details_bloc.dart';
import 'package:flutter/material.dart';

class NotesDetails extends StatefulWidget {
  const NotesDetails({super.key});

  @override
  State<NotesDetails> createState() {
    return _NotesDetailsState();
  }
}

class _NotesDetailsState extends State<NotesDetails> {
  final NotesDetailsBloc _bloc = NotesDetailsBloc();

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
