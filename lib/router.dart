import 'package:bbk_final_ana/auth/screens/login_screen.dart';
import 'package:bbk_final_ana/common/screens/error_screen.dart';
import 'package:bbk_final_ana/landing/screens/welcome_screen.dart';
import 'package:bbk_final_ana/messaging/chat/screens/chat_screen.dart';
import 'package:bbk_final_ana/messaging/conversations/screens/conversations_screen.dart';
import 'package:bbk_final_ana/messaging/group/screens/create_group_screen.dart';
import 'package:bbk_final_ana/screens/home_screen.dart';
import 'package:bbk_final_ana/audio/screens/initial_decision_screen.dart';
import 'package:bbk_final_ana/auth/screens/user_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth/screens/registration_screen.dart';
import 'messaging/select_contacts/screens/select_contact_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case WelcomeScreen.id:
      return MaterialPageRoute(builder: (context) => const WelcomeScreen());

    case RegistrationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const RegistrationScreen());

    case LoginScreen.id:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case InitialDecisionScreen.id:
      return MaterialPageRoute(
          builder: (context) => const InitialDecisionScreen());

    case UserInformationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());

    case SelectContactScreen.id:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());

    case CreateGroupScreen.id:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());

    case ChatScreen.id:
      final args = settings.arguments as Map<String, dynamic>;
      final name = args['name'];
      final uid = args['uid'];
      final isGroupChat = args['isGroupChat'];
      final profilePicture = args['profilePicture'];
      return MaterialPageRoute(
          builder: (context) => ChatScreen(
              name: name,
              uid: uid,
              isGroupChat: isGroupChat,
              profilePicture: profilePicture));

    case ConversationsScreen.id:
      return MaterialPageRoute(
          builder: (context) => const ConversationsScreen());

    case HomeScreen.id:
      return MaterialPageRoute(builder: (context) => const HomeScreen());

    default:
      return MaterialPageRoute(
          builder: (context) =>
              const ErrorScreen(error: 'This page does not exist.'));
  }
}
