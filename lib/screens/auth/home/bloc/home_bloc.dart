import 'package:firebase_database/firebase_database.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/genrerate_folder_model.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snug_logger/snug_logger.dart';

class HomeBloc {
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<ApiResponse<GenerateFolderModel>> _createFolder =
      BehaviorSubject<ApiResponse<GenerateFolderModel>>();

  BehaviorSubject<ApiResponse<GenerateFolderModel>> get createFolder =>
      _createFolder;

  final BehaviorSubject<List<GenerateFolderModel>> _folders =
      BehaviorSubject<List<GenerateFolderModel>>();

  BehaviorSubject<List<GenerateFolderModel>> get folders => _folders;

  Stream<bool> get isLoading => _isLoading.stream;

  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .ref('folders/${AppStore.store?.state.user?.uid}');

  void setLoading(bool value) {
    _isLoading.add(value);
  }

  Future<void> generateFolder(String folderName) async {
    try {
      setLoading(true);

      final DateTime currentDate = DateTime.now();

      final DatabaseReference databaseReference = _dbRef.push();

      snugLog('databaseReference: ${databaseReference.key}');

      final GenerateFolderModel folder = GenerateFolderModel(
        id: databaseReference.key,
        name: folderName,
        date: currentDate.millisecondsSinceEpoch,
      );

      await databaseReference.set(folder.toJson());
      _createFolder.sink.add(ApiResponse.completed(folder));
      setLoading(false);
    } catch (e) {
      snugLog(e);
      _createFolder.sink.add(ApiResponse.error(e.toString()));
      setLoading(false);
    }
  }

  Future<void> fetchFolders() async {
    try {
      setLoading(true);
      _dbRef.orderByChild('date').onValue.listen((event) {
        if (event.snapshot.exists) {
          final List<GenerateFolderModel> folders = <GenerateFolderModel>[];

          final Map<String, dynamic> data =
              Map<String, dynamic>.from(event.snapshot.value as Map);

          data.forEach((key, value) {
            final GenerateFolderModel folder =
                GenerateFolderModel.fromJson(value);
            folders.add(folder);
          });

          _folders.sink.add(folders);
          setLoading(false);
        } else {
          _folders.sink.add([]);
          setLoading(false);
        }
      });
    } catch (e, st) {
      snugLog(
        'folder fetching Error ::: $e',
        stackTrace: st,
        logType: LogType.error,
      );
      setLoading(false);
    }
  }

  void dispose() {
    _isLoading.close();
  }
}
