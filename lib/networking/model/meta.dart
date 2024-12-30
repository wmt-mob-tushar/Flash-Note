class Meta {
  String? _message;
  dynamic _status;

  String? get message => _message;
  dynamic get status => _status;

  Meta({String? message, dynamic status}) {
    _message = message;
    _status = status;
  }

  Meta.fromJson(dynamic json) {
    _message = json["message"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = _message;
    map["status"] = _status;

    return map;
  }
}
