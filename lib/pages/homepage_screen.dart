import 'dart:math';
import 'package:flutter/material.dart';
import '/class/questions.dart';
import '/model/question_model.dart';
import '/router/constant.dart';
import '/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  final List<QuestionModel> argument;

  HomePage({this.argument});

  @override
  _HomePageState createState() => _HomePageState(model: argument);
}

class _HomePageState extends State<HomePage> {
  final List<QuestionModel> model;
  final question = Questions();
  var title = "OKUYUNUZ";
  var str =
      "Doğruluk mu / Cesaretlik mi sorularını görebilmek için aşağıdaki butonlardan seçim yaparak başlayınız.";
  bool enabledTruth = true;
  bool enabledDare = true;
  bool showQuestion = true;
  List myTruthList = [];
  List myDareList = [];

  _HomePageState({@required this.model});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          backgroundColor: Colors.blue[600],
          title: Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Card(
                    elevation: 7,
                    margin: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 40,
                    ),
                    color: Colors.pink[200],
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                str,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: showQuestion
                                      ? () => truthFunction("DOĞRULUK")
                                      : () => myTruthFunction(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "DOĞRULUK",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  color:
                                      enabledTruth ? Colors.green : Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: showQuestion
                                      ? () => dareFunction("CESARETLİK")
                                      : () => myDareFunction(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "CESARETLİK",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  color:
                                      enabledDare ? Colors.orange : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                              onTap: _onTapMyQuestion,
                              child: Text(
                                "Benim sorularım ile başlasın",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.refresh,
                                size: 35,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, HomePageView);
                              },
                            ),
                            Text(
                              "Refresh Game",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onTapMyQuestion() {
    if (model != null && model.isNotEmpty) {
      setState(() {
        showQuestion = false;
        title = "OKUYUNUZ";
        str =
            "Doğruluk mu / Cesaretlik mi sorularını görebilmek için aşağıdaki butonlardan seçim yaparak başlayınız.";
      });
      model.forEach((element) {
        if (element.title == "Doğruluk") {
          myTruthList.add(element.question);
        } else {
          myDareList.add(element.question);
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Öncelikle soru eklemelisiniz."),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Okay"),
              )
            ],
          );
        },
      );
    }
  }

  showAlertDialog(BuildContext context, String str) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: Text("Tamam"),
      onPressed: () => Navigator.pop(context, false),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content:
          Text("$str soruları bitti. Dilerseniz soruları sıfırlayabilirsiniz."),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  myTruthFunction() {
    if (myTruthList.isNotEmpty) {
      var rand = Random().nextInt(myTruthList.length);
      setState(
        () {
          str = myTruthList[rand];
          title = "DOĞRULUK";
        },
      );
    }
  }

  myDareFunction() {
    if (myDareList.isNotEmpty) {
      var rand = Random().nextInt(myDareList.length);
      setState(
        () {
          str = myDareList[rand];
          title = "CESARETLİK";
        },
      );
    }
  }

  bool truthFunction(String type) {
    if (enabledTruth) {
      var rand = Random().nextInt(question.questionsTruth.length);
      setState(
        () {
          str = question.questionsTruth[rand];
          question.questionsTruth.removeAt(rand);
          title = type;
        },
      );

      if (question.questionsTruth.length == 1) {
        enabledTruth = false;
        showAlertDialog(context, title);
      }
    }

    return enabledTruth;
  }

  bool dareFunction(String type) {
    if (enabledDare) {
      var rand = Random().nextInt(question.questionsDare.length);
      setState(() {
        str = question.questionsDare[rand];
        question.questionsDare.removeAt(rand);
        title = type;
      });

      if (question.questionsDare.length == 1) {
        enabledDare = false;
        showAlertDialog(context, title);
      }
    }

    return enabledDare;
  }
}
