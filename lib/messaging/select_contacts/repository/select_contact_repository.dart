import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod/riverpod.dart';

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
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedEmail = selectedContact.emails[0].address;
        if (selectedEmail == userData.email) {
          isFound = true;
          //TODO: create ChatScreen
          // Navigator.pushNamed(
          //   context,
          //   MobileChatScreen.routeName,
          //   arguments: {
          //     'name': userData.name,
          //     'uid': userData.uid,
          //   },
          // );
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context, content: 'Contact not registed on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
