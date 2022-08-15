import 'dart:io';

import 'package:bbk_final_ana/common/repositories/common_firestore_repository.dart';
import 'package:bbk_final_ana/models/group.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref,
    ));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePicture,
      List<Contact> selectedContacts) async {
    try {
      List<String> userIds = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where('email', isEqualTo: selectedContacts[i].emails[0])
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          userIds.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'group/$groupId',
            profilePicture,
          );
      Group group = Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPicture: profileUrl,
        membersUid: [auth.currentUser!.uid, ...userIds],
        timeSent: DateTime.now(),
      );
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } on Exception catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
