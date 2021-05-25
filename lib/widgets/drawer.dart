import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama_projesi/class/user_preferences.dart';
import 'package:mobil_uygulama_projesi/model/user.dart';
import 'package:mobil_uygulama_projesi/pages/login_screen.dart';
import 'package:mobil_uygulama_projesi/router/constant.dart';
import 'package:mobil_uygulama_projesi/service/authentication.dart';
import 'package:mobil_uygulama_projesi/service/database.dart';
import 'package:mobil_uygulama_projesi/widgets/loading.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final DatabaseService _databaseService = DatabaseService();
  final AuthenticationService _auth = AuthenticationService();

  String useruid;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    Provider.of<UserPreferences>(context, listen: false).loadPref();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
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

              return Drawer(
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[500],
                          Colors.blue[800],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListView(
                      children: [
                        SizedBox(height: size * 0.04),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 1, child: imagePlace()),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 10,
                                    children: [
                                      Text(
                                        "Welcome!",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        userData.nameSurname,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                              color: Colors.white70, height: size * 0.08),
                        ),
                        Container(
                          child: Column(
                            children: [
                              buildMenuItem(
                                  text: "Create Questions",
                                  icon: Icons.add_alert,
                                  size: size * 0.03,
                                  onClicked: () => selectedItem(context, 0)),
                              SizedBox(height: size * 0.03),
                              buildMenuItem(
                                  text: "Person",
                                  icon: Icons.person,
                                  size: size * 0.03,
                                  onClicked: () => selectedItem(context, 1)),
                              SizedBox(height: size * 0.03),
                              buildMenuItem(
                                  text: "Contact",
                                  icon: Icons.contact_support_sharp,
                                  size: size * 0.03,
                                  onClicked: () => selectedItem(context, 2)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                              color: Colors.white70, height: size * 0.08),
                        ),
                        _logoutButton(),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Loading();
            }
          }
        });
  }

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: imageUrl != ""
          ? NetworkImage(imageUrl)
          : AssetImage("assets/images/person-icon.png"),
      radius: height * 0.05,
    );
  }

  Widget _logoutButton() {
    double size = MediaQuery.of(context).size.height;
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: Colors.white,
        size: size * 0.03,
      ),
      title: Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: () async {
        await Provider.of<UserPreferences>(context, listen: false).deletePref();
        await _auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false));
      },
    );
  }
}

Widget buildMenuItem(
    {@required String text,
    @required IconData icon,
    double size,
    VoidCallback onClicked}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(
      icon,
      color: color,
      size: size,
    ),
    hoverColor: hoverColor,
    title: Text(text, style: TextStyle(color: color, fontSize: 18)),
    onTap: onClicked,
  );
}

void selectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
  switch (index) {
    case 0:
      Navigator.pushNamed(context, CreateQuestionView);
      break;
    case 1:
      Navigator.pushNamed(context, PersonPageView);
      break;
    case 2:
      Navigator.pushNamed(context, ContactPageView);
      break;
    default:
  }
}
