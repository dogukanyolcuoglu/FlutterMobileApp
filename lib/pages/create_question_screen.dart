import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/model/question_model.dart';
import '/router/constant.dart';

class CreateQuestion extends StatefulWidget {
  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  final _textController = TextEditingController();
  String _chosenValue;
  List<QuestionModel> _questions = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, HomePageView, arguments: _questions);
          },
        ),
        elevation: 4,
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        title: Text(
          "Create Question",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size - 120,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add Your Questions",
                          style: TextStyle(fontSize: 30, fontFamily: "Futura"),
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Text(
                        "Question Title:",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: size * 0.04,
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            fillColor: Colors.blue[200]),
                        items: <String>[
                          'Doğruluk',
                          'Cesaretlik',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Please choose a title",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                            print(_chosenValue);
                          });
                        },
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Text(
                        "Question Place:",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.pink[400],
                              Colors.purple[300],
                            ],
                          ),
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(5, 7),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: _textController,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: "Write Question",
                            hintStyle:
                                TextStyle(fontSize: 20, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          obscureText: false,
                          expands: true,
                          maxLines: null,
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tapAddButton,
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  _tapAddButton() {
    if (_chosenValue != null && _textController.text.isNotEmpty) {
      setState(() {
        _questions.add(
            QuestionModel(title: _chosenValue, question: _textController.text));
        _textController.text = "";
      });
      Fluttertoast.showToast(
        msg: "Question adding success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[300],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else {
      print("Null field");
    }
  }
}
