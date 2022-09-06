import 'package:bbk_final_ana/audio/controller/audio_handler.dart';
import 'package:bbk_final_ana/audio/screens/initial_decision_screen.dart';
import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/screens/error_screen.dart';
import 'package:bbk_final_ana/router.dart';
import 'package:bbk_final_ana/landing/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/screens/loader_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initAudioService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widgets is the root of the application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sabiá',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: kGreenOlivine,
          elevation: 0.0,
        ),
        fontFamily: 'Lato',
        scaffoldBackgroundColor: kGreenOlivine,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null) {
              return const WelcomeScreen();
            }
            return const InitialDecisionScreen();
          },
          error: (e, trace) {
            return ErrorScreen(error: e.toString());
          },
          loading: () => const LoaderScreen()),
    );
  }
}
