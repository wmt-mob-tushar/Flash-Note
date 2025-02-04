import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/fetch_folder_data.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snug_logger/snug_logger.dart';

class HomeBloc {
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<ApiResponse<FetchFolderData>> _createFolder =
      BehaviorSubject<ApiResponse<FetchFolderData>>();

  BehaviorSubject<ApiResponse<FetchFolderData>> get createFolder =>
      _createFolder;

  final BehaviorSubject<List<FetchFolderData>> _folders =
      BehaviorSubject<List<FetchFolderData>>();

  BehaviorSubject<List<FetchFolderData>> get folders => _folders;

  Stream<bool> get isLoading => _isLoading.stream;

  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .ref('folders/${AppStore.store?.state.user?.uid}');

  void setLoading(bool value) {
    _isLoading.add(value);
  }

  Future<void> generateFolder(String folderName) async {
    try {
      setLoading(true);

      final DatabaseReference databaseReference = _dbRef.push();

      snugLog('databaseReference: ${databaseReference.key}');

      final FetchFolderData folder = FetchFolderData();

      await databaseReference.set({
        "id": databaseReference.key,
        "folderName": folderName,
        "createdAt": ServerValue.timestamp,
      });
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
      _dbRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          final List<FetchFolderData> folders = <FetchFolderData>[];

          final Map<String, dynamic> data =
              Map<String, dynamic>.from((event.snapshot.value ?? "") as Map);

          data.forEach((key, value) {
            final FetchFolderData folder = FetchFolderData.fromJson(value);
            folders.add(folder);
          });

          //sort data on createdAt
          folders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

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
