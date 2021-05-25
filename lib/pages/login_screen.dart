import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama_projesi/router/constant.dart';
import 'package:mobil_uygulama_projesi/service/authentication.dart';
import 'package:mobil_uygulama_projesi/class/user_preferences.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHiddenPassword = true;
  String _errorTextEmail, _errorTextPassword;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _auth = AuthenticationService();

  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[800],
                Colors.blue[600],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(flex: 4),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Welcome back",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Expanded(child: emailTextField(context)),
                              Expanded(child: passwordTextField(context)),
                            ],
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, ResetPasswordView);
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue[800],
                                  Colors.blue[500],
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: checkLogin,
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 7),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't Have An Account? ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SignUpPageView);
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  void checkLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (_emailController.text.isEmpty) {
        setState(() {
          _errorTextEmail = "This field is empty";
          _errorTextPassword = null;
        });
      }
      if (_passwordController.text.isEmpty) {
        setState(() {
          _errorTextPassword = "This field is empty";
          _errorTextEmail = null;
        });
      }
      if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
        setState(() {
          _errorTextEmail = "This field is empty";
          _errorTextPassword = "This field is empty";
        });
      }
    } else {
      setState(() {
        _errorTextEmail = null;
        _errorTextPassword = null;
      });
      dynamic result = await _auth.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (result is String) {
        showAlertDialogMessage(result);
      } else {
        onRefresh(FirebaseAuth.instance.currentUser);
        if (user.emailVerified) {
          await Provider.of<UserPreferences>(context, listen: false)
              .savePref(user);
          Navigator.pushNamed(context, HomePageView);
        } else {
          showAlertDialogMessage("Please firstly verifiy your email");
        }
      }
    }
  }

  void showAlertDialogMessage(String message) {
    Widget okButton = FlatButton(
      onPressed: () {
        Navigator.pop(context, false);
      },
      child: Text("Okay"),
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text("Warning"),
      content: Text(message),
      actions: [okButton],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget emailTextField(BuildContext context) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: _errorTextEmail,
        errorStyle: TextStyle(fontSize: 15),
        hintText: "E-mail",
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            width: 3,
            color: Colors.blue,
          ),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.blue[400],
        ),
      ),
    );
  }

  Widget passwordTextField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: _isHiddenPassword,
      decoration: InputDecoration(
        errorText: _errorTextPassword,
        errorStyle: TextStyle(fontSize: 15),
        hintText: "Password",
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            width: 3,
            color: Colors.blue,
          ),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.blue[400],
        ),
        suffixIcon: InkWell(
          onTap: _togglePasswordView,
          child: _isHiddenPassword == false
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
        ),
      ),
    );
  }
}
