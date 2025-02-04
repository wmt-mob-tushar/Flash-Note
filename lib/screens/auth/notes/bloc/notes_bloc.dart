import 'package:firebase_database/firebase_database.dart';
import 'package:flash_note/networking/model/note_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snug_logger/snug_logger.dart';

class NotesBloc {
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoading => _isLoading.stream;

  final BehaviorSubject<List<NoteModel>> _notes =
      BehaviorSubject<List<NoteModel>>.seeded([]);

  Stream<List<NoteModel>> get notes => _notes.stream;

  void setLoading(bool value) {
    _isLoading.add(value);
  }

  Future<void> fetchNotes(
    String folderId,
  ) async {
    try {
      setLoading(true);

      final DatabaseReference dbRef = FirebaseDatabase.instance
          .ref('notes/$folderId');

      dbRef.orderByChild('createdAt').onValue.listen((event) {
        if (event.snapshot.exists) {
          final List<NoteModel> notes = <NoteModel>[];

          final Map<String, dynamic> data =
              Map<String, dynamic>.from((event.snapshot.value ?? "") as Map);

          data.forEach((key, value) {
            final NoteModel folder =
            NoteModel.fromJson(value);
            notes.add(folder);
          });

          notes
              .sort((a, b) => (a.createdAt ?? 0).compareTo(b.createdAt ?? 0));

          _notes.sink.add(notes);
          setLoading(false);
        } else {
          _notes.sink.add([]);
          setLoading(false);
        }
      });
    } catch (e, st) {
      snugLog(
        'notes fetching Error ::: $e',
        stackTrace: st,
        logType: LogType.error,
      );
      setLoading(false);
    }
  }

  dispose() {
    _isLoading.close();
    _notes.close();
  }
}
