import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //Upload Media
  Future<String> uploadMedia(File file) async {
    var mediaUrl =
        "Media/${DateTime.now().microsecondsSinceEpoch}.${file.path.split('.').last}";

    var uploadTask = _firebaseStorage.ref().child(mediaUrl).putFile(file);

    uploadTask.snapshotEvents.listen((event) {});
    var storage = await uploadTask.whenComplete(() => null);

    return await storage.ref.getDownloadURL();
  }
}
