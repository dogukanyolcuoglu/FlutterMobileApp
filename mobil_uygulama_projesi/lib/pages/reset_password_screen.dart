import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama_projesi/router/constant.dart';
import 'package:mobil_uygulama_projesi/service/authentication.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String _warning, _errorText;
  final _emailController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(flex: 1, child: showAlert()),
                Expanded(
                  flex: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Column(
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorText: _errorText,
                                errorStyle: TextStyle(fontSize: 18),
                                hintText: "E-mail",
                                hintStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Spacer(flex: 1),
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              color: Colors.green,
                              onPressed: () {
                                setState(() {
                                  if (_emailController.text != "") {
                                    if (!_emailController.text
                                            .contains("@gmail.com") &&
                                        !_emailController.text
                                            .contains("@hotmail.com")) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Warning"),
                                            content: Text(
                                                "The email address is badly formatted."),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text("Okay"),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      dynamic result = _authenticationService
                                          .resetPassword(_emailController.text);
                                      if (result is String) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Warning"),
                                              content: Text(result),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: Text("Okay"),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        _warning =
                                            "A password reset link has been sent to ${_emailController.text}";
                                        _errorText = null;
                                      }
                                    }
                                  } else {
                                    _errorText = "This field is empty";
                                  }
                                });
                              },
                            ),
                          ),
                          Spacer(flex: 1),
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                "Back",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, LoginPageView);
                              },
                            ),
                          ),
                          Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
