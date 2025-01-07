/// uid : "kldshkljf"
/// noteTitle : "ksdklkldsf"
/// description : "lskdjkjkdfjldfjg"
/// date : "03-11-12"
/// color : "#fffff"

class NoteModel {
  NoteModel({
    String? id,
    String? noteTitle,
    String? description,
    int? date,
    int? colorIndex,}){
    _id = id;
    _noteTitle = noteTitle;
    _description = description;
    _date = date;
    _colorIndex = colorIndex;
  }

  NoteModel.fromJson(dynamic json) {
    _id = json['id'];
    _noteTitle = json['noteTitle'];
    _description = json['description'];
    _date = json['date'];
    _colorIndex = json['color'];
  }
  String? _id;
  String? _noteTitle;
  String? _description;
  int? _date;
  int? _colorIndex;
  NoteModel copyWith({
    String? id,
    String? noteTitle,
    String? description,
    int? date,
    int? colorIndex,
  }) => NoteModel(
    id: id ?? _id,
    noteTitle: noteTitle ?? _noteTitle,
    description: description ?? _description,
    date: date ?? _date,
    colorIndex:colorIndex  ?? _colorIndex,
  );
  String? get id => _id;
  String? get noteTitle => _noteTitle;
  String? get description => _description;
  int? get date => _date;
  int? get colorIndex => _colorIndex;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['noteTitle'] = _noteTitle;
    map['description'] = _description;
    map['date'] = _date;
    map['colorIndex'] = _colorIndex;
    return map;
  }

}