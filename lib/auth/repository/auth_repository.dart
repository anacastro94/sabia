import 'dart:io';

import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/landing/screens/welcome_screen.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/repositories/common_firestore_repository.dart';

/// According to Riverpod documentation, all providers must
/// be declared as global variables.
final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) async {
    bool didSucceed = true;
    try {
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (e) {
      didSucceed = false;
      showSnackBar(context: context, content: e.toString());
    }
    return didSucceed;
  }

  Future<bool> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    bool didSucceed = true;
    try {
      final newUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (e) {
      didSucceed = false;
      showSnackBar(context: context, content: e.toString());
    }
    return didSucceed;
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePicture,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = kStandardProfilePicUrl;
      if (profilePicture != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePicture/$uid', profilePicture);
      }
      var user = UserModel(
        name: name,
        uid: uid,
        profilePicture: photoUrl,
        isOnline: true,
        email: auth.currentUser!.email.toString(),
        groupId: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
    } on Exception catch (e) {
      print(e);
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> getUserDataById(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(event.data()!),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  void logCurrentUserOut(BuildContext context) async {
    try {
      await auth.signOut().then(
            (_) => Navigator.pushNamedAndRemoveUntil(
                context, WelcomeScreen.id, (route) => false),
          );
    } on Exception catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
