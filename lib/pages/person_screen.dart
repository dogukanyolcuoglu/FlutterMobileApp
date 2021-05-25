import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobil_uygulama_projesi/class/user_preferences.dart';
import 'package:mobil_uygulama_projesi/model/user.dart';
import 'package:mobil_uygulama_projesi/service/database.dart';
import 'package:mobil_uygulama_projesi/widgets/loading.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final DatabaseService _databaseService = DatabaseService();

  String useruid;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    Provider.of<UserPreferences>(context, listen: false).loadPref();
  }

  @override
  Widget build(BuildContext context) {
    useruid = Provider.of<UserPreferences>(context).uid;

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
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 22, 16, 12),
                        padding: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 6,
                              offset: Offset(2.0, 4.0),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  imagePlace(),
                                  Positioned(
                                    right: 12,
                                    bottom: 22,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.photo_camera,
                                        size: 30,
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
                              flex: 4,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Wrap(
                                  runSpacing: 20,
                                  children: [
                                    Wrap(
                                      spacing: 30,
                                      runSpacing: 3,
                                      children: [
                                        Text(
                                          "Name Surname:",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          userData.nameSurname,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 3,
                                      children: [
                                        Text(
                                          "Email:",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          userData.email,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(),
                    )
                  ],
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

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      radius: height,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: imageUrl != ""
            ? NetworkImage(imageUrl)
            : AssetImage("assets/images/person-icon.png"),
        radius: height * 0.08,
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
      } else {
        print("No Path Received");
      }
    } else {
      if (profileImage != null) {
        //Upload Image
        _databaseService.addMedia(file, useruid);
      } else {
        print("No Path Received");
      }
    }
  }
}
