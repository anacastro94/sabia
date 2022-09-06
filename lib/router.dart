import 'package:bbk_final_ana/auth/screens/login_screen.dart';
import 'package:bbk_final_ana/common/screens/error_screen.dart';
import 'package:bbk_final_ana/landing/screens/welcome_screen.dart';
import 'package:bbk_final_ana/messaging/chat/screens/chat_screen.dart';
import 'package:bbk_final_ana/messaging/conversations/screens/conversations_screen.dart';
import 'package:bbk_final_ana/messaging/group/screens/create_group_screen.dart';
import 'package:bbk_final_ana/audio/screens/initial_decision_screen.dart';
import 'package:bbk_final_ana/auth/screens/user_info_screen.dart';

import 'package:flutter/material.dart';

import 'audio/screens/author_title_cover_screen.dart';
import 'audio/screens/library_screen.dart';
import 'audio/screens/player_screen.dart';
import 'audio/screens/recorder_screen.dart';
import 'audio/screens/send_to_screen.dart';
import 'auth/screens/edit_user_info_screen.dart';
import 'auth/screens/registration_screen.dart';
import 'messaging/select_contacts/screens/select_user_contact_screen.dart';

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

    case EditUserInformationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const EditUserInformationScreen());

    case SelectUserContactScreen.id:
      return MaterialPageRoute(
          builder: (context) => const SelectUserContactScreen());

    case CreateGroupScreen.id:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());

    case LibraryScreen.id:
      return MaterialPageRoute(builder: (context) => const LibraryScreen());

    case PlayerScreen.id:
      return MaterialPageRoute(builder: (context) => const PlayerScreen());

    case RecorderScreen.id:
      return MaterialPageRoute(builder: (context) => const RecorderScreen());

    case AuthorTitleCoverScreen.id:
      return MaterialPageRoute(
          builder: (context) => const AuthorTitleCoverScreen());

    case SendToScreen.id:
      return MaterialPageRoute(builder: (context) => const SendToScreen());

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

    default:
      return MaterialPageRoute(
          builder: (context) =>
              const ErrorScreen(error: 'This page does not exist.'));
  }
}
