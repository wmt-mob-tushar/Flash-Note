import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux_persist/redux_persist.dart';

class AppStorage implements StorageEngine {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  static const _key = 'app';

  @override
  Future<Uint8List?> load() async {
    final data = await _storage.read(key: _key);
    if (data == null) return null;
    return Uint8List.fromList(data.codeUnits);
  }

  @override
  Future<void> save(Uint8List? data) async {
    if (data == null) {
      await _storage.delete(key: _key);
    } else {
      final string = String.fromCharCodes(data);
      await _storage.write(key: _key, value: string);
    }
  }
}
