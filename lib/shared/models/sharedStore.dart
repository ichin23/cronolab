import 'dart:convert';

import 'package:firedart/auth/token_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedStore extends TokenStore {
  static SharedPreferences? pref;

  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void delete() async {
    await pref!.remove("token");
  }

  @override
  Token? read() {
    String? tokenStr = pref!.getString("token");
    if (tokenStr == null) {
      return null;
    } else {
      Token.fromMap(jsonDecode(tokenStr));
    }
    return null;
  }

  @override
  void write(Token? token) async {
    if (token != null) {
      pref!.setString("token", jsonEncode(token.toMap()));
    }
  }
}
