import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences extends ChangeNotifier {
  static SharedPreferences _sharedPreferences;

  String _uid;

  String get uid => _uid;

  Future<void> createPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  savePref(User user) {
    _sharedPreferences.setString('uid', user.uid);
    print("save pref:" + user.uid);
  }

  loadPref() {
    _uid = _sharedPreferences.getString('uid') ?? null;
  }

  deletePref() {
    _sharedPreferences.remove('uid');
  }
}
