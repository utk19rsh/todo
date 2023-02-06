import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences();

  final String _nameKey = "name",
      _uIDKey = "uID",
      _idKey = "id",
      _emailKey = "emailKey",
      _profileImageUrlKey = "profileImageUrl",
      _serverAuthCodeKey = "serverAuthCode";

  String get nameKey => _nameKey;
  String get uIDKey => _uIDKey;
  String get idKey => _idKey;
  String get emailKey => _emailKey;
  String get profileImageUrlKey => _profileImageUrlKey;
  String get serverAuthCodeKey => _serverAuthCodeKey;

  setPreferences(Map<String, dynamic> map) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(uIDKey, map["uID"]!);
    if (map["name"] != null) {
      sp.setString(nameKey, map["name"]!);
    }
    if (map["id"] != null) {
      sp.setString(idKey, map["id"]!);
    }
    if (map["email"] != null) {
      sp.setString(emailKey, map["email"]!);
    }
    if (map["profileImageUrl"] != null) {
      sp.setString(profileImageUrlKey, map["profileImageUrl"]!);
    }
    if (map["serverAuthCode"] != null) {
      sp.setString(serverAuthCodeKey, map["serverAuthCode"]!);
    }
  }
}
