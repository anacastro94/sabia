import 'dart:io';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

final commonFirebaseStorageRepositoryProvider = Provider((ref) =>
    CommonFirebaseStoreRepository(firebaseStorage: FirebaseStorage.instance));

class CommonFirebaseStoreRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStoreRepository({required this.firebaseStorage});

  Future<String> storeFileToFirebase(String path, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
