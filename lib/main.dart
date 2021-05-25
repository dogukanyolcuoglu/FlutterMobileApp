import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/class/user_preferences.dart';
import '/router/constant.dart';
import 'package:provider/provider.dart';
import '/router/route.dart' as route;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences().createPref();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserPreferences()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: DecisionsPageView,
      onGenerateRoute: route.generateRoute,
    );
  }
}
