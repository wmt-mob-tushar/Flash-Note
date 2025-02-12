import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/note_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snug_logger/snug_logger.dart';

class NotesDetailsBloc {
  final List<String> tags = [];

  final BehaviorSubject<ApiResponse<NoteModel>> _addNoteResponse =
      BehaviorSubject<ApiResponse<NoteModel>>();

  BehaviorSubject<ApiResponse<NoteModel>> get addNoteResponse =>
      _addNoteResponse;

  final BehaviorSubject<List<String>> _multiSelectTags =
  BehaviorSubject<List<String>>.seeded([]);

  BehaviorSubject<List<String>> get multiSelectTags => _multiSelectTags;

  Future<void> addNote(String title, String content) async {
    try {} catch (e, st) {
      snugLog("Error saving note: $e", stackTrace: st);
    }
  }

  void createTag(String tag) {
    if (!tags.contains(tag)) {
      tags.add(tag);
      _multiSelectTags.add(tags);
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
    _multiSelectTags.add(List.from(tags));
  }

  void removeLastTag() {
    if (tags.isNotEmpty) {
      tags.removeLast();
      _multiSelectTags.add(List.from(tags));
    }
  }


  dispose() {
    _addNoteResponse.close();
  }
}
