class NoteModel {
  NoteModel({
    String? id,
    String? folderId,
    String? noteTitle,
    String? description,
    int? createdAt,
    int? updatedAt,
    String? status,
    List<String>? tags,
    int? colorIndex,
  }) {
    _id = id;
    _folderId = folderId;
    _noteTitle = noteTitle;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _tags = tags ?? [];
    _colorIndex = colorIndex;
  }

  NoteModel.fromJson(dynamic json) {
    _id = json['id'];
    _folderId = json['folderId'];
    _noteTitle = json['title'];
    _description = json['description'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _tags = json['tags'] != null ? List<String>.from(json['tags']) : [];
    _colorIndex = json['colorIndex'];
  }

  String? _id;
  String? _folderId;
  String? _noteTitle;
  String? _description;
  int? _createdAt;
  int? _updatedAt;
  String? _status;
  List<String>? _tags;
  int? _colorIndex;

  NoteModel copyWith({
    String? id,
    String? folderId,
    String? noteTitle,
    String? description,
    int? createdAt,
    int? updatedAt,
    String? status,
    List<String>? tags,
    int? colorIndex,
  }) =>
      NoteModel(
        id: id ?? _id,
        folderId: folderId ?? _folderId,
        noteTitle: noteTitle ?? _noteTitle,
        description: description ?? _description,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        status: status ?? _status,
        tags: tags ?? _tags,
        colorIndex: colorIndex ?? _colorIndex,
      );

  String? get id => _id;
  String? get folderId => _folderId;
  String? get noteTitle => _noteTitle;
  String? get description => _description;
  int? get createdAt => _createdAt;
  int? get updatedAt => _updatedAt;
  String? get status => _status;
  List<String>? get tags => _tags;
  int? get colorIndex => _colorIndex;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['folderId'] = _folderId;
    map['title'] = _noteTitle;
    map['description'] = _description;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    map['tags'] = _tags;
    map['colorIndex'] = _colorIndex;
    return map;
  }
}
