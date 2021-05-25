import 'package:flutter/material.dart';
import '/pages/homepage_screen.dart';
import '/pages/login_screen.dart';
import '/class/user_preferences.dart';
import 'package:provider/provider.dart';

class DecisionTree extends StatefulWidget {
  @override
  _DecisionTreeState createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  void initState() {
    super.initState();
    Provider.of<UserPreferences>(context, listen: false).loadPref();
  }

  @override
  Widget build(BuildContext context) {
    final useruid = Provider.of<UserPreferences>(context).uid;
    if (useruid == null) {
      print("decision: $useruid");
      return LoginPage();
    }
    print("decision: " + useruid);
    return HomePage();
  }
}
