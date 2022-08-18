import 'package:bbk_final_ana/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod/riverpod.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<UserModel>> getUserContacts() async {
    List<UserModel> userContacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        var allDeviceContacts =
            await FlutterContacts.getContacts(withProperties: true);
        List<String> myContactsEmailAddresses = [];
        for (var contact in allDeviceContacts) {
          for (var email in contact.emails) {
            myContactsEmailAddresses.add(email.address);
          }
        }
        var userCollection = await firestore.collection('users').get();
        for (var document in userCollection.docs) {
          var userData = UserModel.fromMap(document.data());
          String registeredEmail = userData.email;
          if (myContactsEmailAddresses.contains(registeredEmail)) {
            userContacts.add(userData);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return userContacts;
  }
}
