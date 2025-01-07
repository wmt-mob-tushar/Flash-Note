/// uid : "lksdkkljkdlf"
/// userName : "tushar"
/// email : "tushar@gmail.com"

class AppUser {
  AppUser({
    String? uid,
    String? userName,
    String? email,
  }){
    _uid = uid;
    _userName = userName;
    _email = email;
  }

  AppUser.fromJson(dynamic json) {
    _uid = json['uid'];
    _userName = json['userName'];
    _email = json['email'];
  }
  String? _uid;
  String? _userName;
  String? _email;
  AppUser copyWith({  String? uid,
    String? userName,
    String? email,
  }) => AppUser(  uid: uid ?? _uid,
    userName: userName ?? _userName,
    email: email ?? _email,
  );
  String? get uid => _uid;
  String? get userName => _userName;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['userName'] = _userName;
    map['email'] = _email;
    return map;
  }

}