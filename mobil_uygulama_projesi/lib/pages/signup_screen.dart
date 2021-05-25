import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobil_uygulama_projesi/router/constant.dart';
import 'package:mobil_uygulama_projesi/service/authentication.dart';
import 'package:mobil_uygulama_projesi/service/database.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _emailError, _nameError, _passwordError, _repasswordError;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final AuthenticationService _auth = AuthenticationService();
  final DatabaseService _db = DatabaseService();

  final userAuth = FirebaseAuth.instance;
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
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(flex: 2),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, LoginPageView);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "Back",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),
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
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              Expanded(child: emailTextField(context)),
                              Expanded(child: usernameTextField(context)),
                              Expanded(child: passwordTextField(context)),
                              Expanded(child: repasswordTextField(context)),
                            ],
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: checkSignup,
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              textColor: Colors.black,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
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

  void checkSignup() async {
    if (_emailController.text.isEmpty ||
        _nameSurnameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repasswordController.text.isEmpty) {
      if (_emailController.text.isEmpty) {
        setState(() {
          _emailError = "This field is empty";
        });
      } else if (_emailController.text.isNotEmpty) {
        setState(() {
          _emailError = null;
        });
      }
      if (_nameSurnameController.text.isEmpty) {
        setState(() {
          _nameError = "This field is empty";
        });
      } else if (_nameSurnameController.text.isNotEmpty) {
        setState(() {
          _nameError = null;
        });
      }
      if (_passwordController.text.isEmpty) {
        setState(() {
          _passwordError = "This field is empty";
        });
      } else if (_passwordController.text.isNotEmpty) {
        setState(() {
          _passwordError = null;
        });
      }
      if (_repasswordController.text.isEmpty) {
        setState(() {
          _repasswordError = "This field is empty";
        });
      } else if (_repasswordController.text.isNotEmpty) {
        setState(() {
          _repasswordError = null;
        });
      }
      if (_emailController.text.isEmpty &&
          _nameSurnameController.text.isEmpty &&
          _passwordController.text.isEmpty &&
          _repasswordController.text.isEmpty) {
        setState(() {
          _emailError = "This field is empty";
          _passwordError = "This field is empty";
          _repasswordError = "This field is empty";
          _nameError = "This field is empty";
        });
      }
    } else {
      setState(() {
        _emailError = null;
        _passwordError = null;
        _repasswordError = null;
        _nameError = null;
      });
      if (_passwordController.text != _repasswordController.text) {
        _passwordError = "The passwords do not match";
        _repasswordError = "The passwords do not match";
      } else {
        setState(() {
          _passwordError = null;
          _repasswordError = null;
        });
        dynamic result = await _auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (result is String) {
          showAlertDialogMessage(result);
        } else {
          await _db.createPerson(
              _emailController.text, _nameSurnameController.text, result.uid);
          userSet(userAuth.currentUser);
          user.sendEmailVerification().then((value) => Fluttertoast.showToast(
                msg: "Email verification link has sent to your email",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.grey[300],
                textColor: Colors.black,
                fontSize: 16.0,
              ));
          setState(() {
            _emailController.text = "";
            _nameSurnameController.text = "";
            _passwordController.text = "";
            _repasswordController.text = "";
          });
        }
      }
    }
  }

  Widget emailTextField(BuildContext context) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: _emailError,
        errorStyle: TextStyle(fontSize: 16),
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

  Widget usernameTextField(BuildContext context) {
    return TextField(
      controller: _nameSurnameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: _nameError,
        errorStyle: TextStyle(fontSize: 16),
        hintText: "Name Surname",
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
          Icons.person,
          color: Colors.blue[400],
        ),
      ),
    );
  }

  Widget passwordTextField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _passwordError,
        errorStyle: TextStyle(fontSize: 16),
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
      ),
    );
  }

  Widget repasswordTextField(BuildContext context) {
    return TextField(
      controller: _repasswordController,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _repasswordError,
        errorStyle: TextStyle(fontSize: 16),
        hintText: "Re-password",
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
      ),
    );
  }

  userSet(getUser) {
    setState(() {
      user = getUser;
    });
  }
}
