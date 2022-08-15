import 'dart:io';

import 'package:bbk_final_ana/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bbk_final_ana/models/user_model.dart';

/// According to Riverpod documentation, all providers must
/// be declared as global variables.
final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) async {
    return await authRepository.signInWithEmail(
      context,
      email,
      password,
    );
  }

  Future<bool> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    return await authRepository.createUserWithEmailAndPassword(
      context,
      email,
      password,
    );
  }

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePicture,
  ) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePicture: profilePicture, ref: ref, context: context);
  }

  Future<UserModel?> getCurrentUserData() async {
    return await authRepository.getCurrentUserData();
  }

  Stream<UserModel> getUserDataById(String userId) {
    return authRepository.getUserDataById(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  void logCurrentUserOut(BuildContext context) {
    authRepository.logCurrentUserOut(context);
  }
}
