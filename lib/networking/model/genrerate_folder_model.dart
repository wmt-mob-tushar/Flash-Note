import 'note_model.dart';

class GenerateFolderModel {
  GenerateFolderModel({
    String? id,
    String? name,
    int? date,
    List<NoteModel>? notes,
  }) {
    _id = id;
    _name = name;
    _date = date;
    _notes = notes ?? [];
  }

  GenerateFolderModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _date = json['date'] is String
        ? DateTime.parse(json['date']).millisecondsSinceEpoch
        : json['date']; // Convert string date to int if necessary

    // Parse Notes List
    if (json['notes'] != null) {
      _notes = List<NoteModel>.from(
          (json['notes'] as List).map((note) => NoteModel.fromJson(note)));
    } else {
      _notes = [];
    }
  }

  String? _id;
  String? _name;
  int? _date;
  List<NoteModel>? _notes;

  GenerateFolderModel copyWith({
    String? id,
    String? name,
    int? date,
    List<NoteModel>? notes,
  }) =>
      GenerateFolderModel(
        id: id ?? _id,
        name: name ?? _name,
        date: date ?? _date,
        notes: notes ?? _notes,
      );

  String? get id => _id;
  String? get name => _name;
  int? get date => _date;
  List<NoteModel>? get notes => _notes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['date'] = _date;
    map['notes'] = _notes?.map((note) => note.toJson()).toList(); // Convert notes list
    return map;
  }

  DateTime? getDateTime() {
    return _date != null ? DateTime.fromMillisecondsSinceEpoch(_date!) : null;
  }
}
