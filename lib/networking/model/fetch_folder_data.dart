/// createdAt : 1738585851118
/// folderName : "hello"
/// id : "-OIAmgIkzn6zLBNsG91x"

class FetchFolderData {
  FetchFolderData({
    num? createdAt,
    String? folderName,
    String? id,
  }) {
    _createdAt = createdAt;
    _folderName = folderName;
    _id = id;
  }

  FetchFolderData.fromJson(dynamic json) {
    _createdAt = json['createdAt'];
    _folderName = json['folderName'];
    _id = json['id'];
  }

  num? _createdAt;
  String? _folderName;
  String? _id;

  FetchFolderData copyWith({
    num? createdAt,
    String? folderName,
    String? id,
  }) =>
      FetchFolderData(
        createdAt: createdAt ?? _createdAt,
        folderName: folderName ?? _folderName,
        id: id ?? _id,
      );

  num? get createdAt => _createdAt;

  String? get folderName => _folderName;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = _createdAt;
    map['folderName'] = _folderName;
    map['id'] = _id;
    return map;
  }
}
