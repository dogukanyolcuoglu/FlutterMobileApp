import 'package:flutter/material.dart';
import '/pages/create_question_screen.dart';
import '/pages/contact_screen.dart';
import '/pages/homepage_screen.dart';
import '/pages/login_screen.dart';
import '/pages/person_screen.dart';
import '/pages/reset_password_screen.dart';
import '/pages/signup_screen.dart';
import '/router/constant.dart';
import '/widgets/decision_tree.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var arg = settings.arguments;

  switch (settings.name) {
    case HomePageView:
      return MaterialPageRoute(builder: (context) => HomePage(argument: arg));
    case LoginPageView:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case SignUpPageView:
      return MaterialPageRoute(builder: (context) => SignupPage());
    case PersonPageView:
      return MaterialPageRoute(builder: (context) => PersonPage());
    case ContactPageView:
      return MaterialPageRoute(builder: (context) => ContactPage());
    case CreateQuestionView:
      return MaterialPageRoute(builder: (context) => CreateQuestion());
    case DecisionsPageView:
      return MaterialPageRoute(builder: (context) => DecisionTree());
    case ResetPasswordView:
      return MaterialPageRoute(builder: (context) => ResetPassword());
    default:
      return MaterialPageRoute(builder: (context) => DecisionTree());
  }
}
