import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod/riverpod.dart';

import '../../chat/screens/chat_screen.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      print('USER COLLECTION SIZE: ${userCollection.size}');
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedEmail = selectedContact.emails[0].address;
        // print('SELECTED EMAIL DEBUG: $selectedEmail');
        // print('IS USER REGISTERED?: ${selectedEmail == userData.email}');
        if (selectedEmail == userData.email) {
          isFound = true;
          Navigator.pushNamed(context, ChatScreen.id, arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'isGroupChat': false,
            'profilePicture': userData.profilePicture,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context, content: 'Contact not registered on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
