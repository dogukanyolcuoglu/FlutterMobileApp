import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/class/user_preferences.dart';
import '/model/user.dart';
import '/service/database.dart';
import '/widgets/loading.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final DatabaseService _databaseService = DatabaseService();
  final _textController = TextEditingController();

  String useruid;
  String imageUrl;
  bool _enabled;

  @override
  void initState() {
    super.initState();
    Provider.of<UserPreferences>(context, listen: false).loadPref();
    _enabled = true;
  }

  @override
  Widget build(BuildContext context) {
    useruid = Provider.of<UserPreferences>(context).uid;
    final size = MediaQuery.of(context).size.height;

    return StreamBuilder<DocumentSnapshot>(
      stream: _databaseService.getData(useruid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return snapshot.error;
        } else {
          if (snapshot.hasData) {
            var data = snapshot.data;
            var userData = User(
              nameSurname: data["nameSurname"],
              email: data["email"],
              image: data["image"],
            );
            imageUrl = userData.image;

            return Scaffold(
              appBar: AppBar(
                elevation: 4,
                centerTitle: true,
                backgroundColor: Colors.blue[600],
                title: Text(
                  "Person",
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
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: imagePlace(),
                                ),
                                Positioned(
                                  right: 98,
                                  bottom: 36,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.photo_camera,
                                      size: size * 0.04,
                                      color: Colors.teal,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "User Information",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 6,
                                      offset: Offset(2.0, 4.0),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Wrap(
                                              spacing: 100,
                                              runSpacing: 0,
                                              children: [
                                                Text(
                                                  "Name Surname:",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextField(
                                                  onChanged: (value) {
                                                    _changeName();
                                                  },
                                                  controller: _textController,
                                                  readOnly: _enabled,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                    ),
                                                    hintText: _enabled == true
                                                        ? userData.nameSurname
                                                        : "",
                                                    suffixIcon: InkWell(
                                                      onTap: _onTapEdit,
                                                      child: _enabled == true
                                                          ? Icon(
                                                              Icons.edit_off,
                                                              color:
                                                                  Colors.black,
                                                            )
                                                          : Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Wrap(
                                              spacing: 100,
                                              runSpacing: 5,
                                              children: [
                                                Text(
                                                  "Email:",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  userData.email,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        }
      },
    );
  }

  void _onTapEdit() {
    setState(() {
      _enabled = !_enabled;
    });
  }

  void _changeName() async {
    return await _databaseService.editNameSurname(
        useruid, _textController.text);
  }

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      radius: height / 4.7,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: imageUrl != ""
            ? NetworkImage(imageUrl)
            : AssetImage("assets/images/person-icon.png"),
        radius: height / 5.3,
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Expanded(
            child: Text(
              "Choose Profile photo",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      uploadImage();
                    },
                    icon: Icon(Icons.image),
                    label: Text("Gallery")),
                FlatButton.icon(
                    onPressed: () {
                      _databaseService.updateData(useruid);
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Remove"))
              ],
            ),
          )
        ],
      ),
    );
  }

  //Check Permissions
  uploadImage() async {
    final _pickerImage = ImagePicker();
    PickedFile profileImage;

    //Select Image
    profileImage = await _pickerImage.getImage(source: ImageSource.gallery);
    var file = File(profileImage.path);

    if (imageUrl != null || imageUrl != "") {
      if (profileImage != null) {
        _databaseService
            .updateData(useruid)
            .then((value) => _databaseService.addMedia(file, useruid));
        Navigator.pop(context, false);
      } else {
        print("No Path Received");
      }
    } else {
      if (profileImage != null) {
        //Upload Image
        _databaseService
            .addMedia(file, useruid)
            .then((value) => Navigator.pop(context, false));
      } else {
        print("No Path Received");
      }
    }
  }
}
