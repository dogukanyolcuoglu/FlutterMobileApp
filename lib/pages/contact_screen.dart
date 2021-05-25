import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final Completer<GoogleMapController> _completer =
      Completer<GoogleMapController>();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        title: Text(
          "Contact",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              markers: Set<Marker>.of(_markers.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(38.4918605, 27.7040623),
                zoom: 17,
              ),
              onMapCreated: (GoogleMapController completer) {
                _completer.complete(completer);
                final MarkerId _markerId = MarkerId("Merkez");
                final Marker _marker = Marker(
                  markerId: _markerId,
                  position: LatLng(38.4918605, 27.7040623),
                  infoWindow: InfoWindow(
                    title: "MCBU",
                    snippet: "Hasan Ferdi Turgutlu Teknoloji Fakültesi",
                    onTap: () {
                      print("işaretci tıklandı");
                    },
                  ),
                );
                setState(() {
                  _markers[_markerId] = _marker;
                });
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(top: 500),
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Contact Information",
                      style: TextStyle(fontSize: 24, fontFamily: "Futura"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      children: [
                        Text(
                          "Adress:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Acarlar, Acarlar Mah. Şehit, Ali Karakuzu Sk. No:10, 45400 Turgutlu/Manisa",
                          style: TextStyle(fontSize: 19),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "School phone number: ",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        TextButton(
                          onPressed: () {
                            _custonLaunch('tel:(0236) 314 10 10');
                          },
                          child: Text(
                            "(0236) 314 10 10",
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                        // Text(
                        //   "(0236) 314 10 10",
                        //   style: TextStyle(fontSize: 19),
                        // )
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _custonLaunch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
