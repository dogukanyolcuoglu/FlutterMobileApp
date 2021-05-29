import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/service/storage.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  String imageUrl = "";

  Future createPerson(String email, String nameSurname, String uid) async {
    try {
      await _firestore.collection("Persons").doc(uid).set({
        'nameSurname': nameSurname,
        'email': email,
        'image': "",
      });
    } catch (e) {
      return null;
    }
  }

  Future addMedia(File file, String uid) async {
    imageUrl = await _storageService.uploadMedia(file);
    try {
      await _firestore.collection("Persons").doc(uid).update(
        {
          'image': imageUrl,
        },
      ).then((value) => print("success uploaded."));
    } catch (e) {
      return e.toString();
    }
  }

  Stream<DocumentSnapshot> getData(String uid) {
    var ref = _firestore.collection("Persons").doc(uid).snapshots();

    return ref;
  }

  Future updateData(String uid) async {
    var ref = await _firestore.collection("Persons").doc(uid).update({
      'image': "",
    });
    return ref;
  }

  Future editNameSurname(String uid, String nameSurname) async {
    try {
      await _firestore.collection("Persons").doc(uid).update({
        'nameSurname': nameSurname,
      }).then((value) => print("success change"));
    } catch (e) {
      return null;
    }
  }
}
