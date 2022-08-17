import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';

import '../../common/widgets/rounded_button_primary.dart';
import '../../audio/screens/initial_decision_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void sendEmailAndPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    bool emailIsValid = EmailValidator.validate(email, true, true);
    if (!emailIsValid) {
      showSnackBar(context: context, content: 'Email is not valid');
      return;
    }
    if (password.isEmpty) {
      //TODO: Improve using password validation
      showSnackBar(context: context, content: 'Password is not valid');
      return;
    }
    final progress = ProgressHUD.of(context);
    progress?.show();
    bool loggedIn = await ref
        .read(authControllerProvider)
        .signInWithEmail(context, email, password);
    progress?.dismiss();
    if (!loggedIn) {
      showSnackBar(context: context, content: 'Login failed.');
      return;
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, InitialDecisionScreen.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(builder: (context) {
        return ScreenBasicStructure(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: kLogoTag,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: emailController,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Email',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: passwordController,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Password',
                ),
                textAlign: TextAlign.center,
                obscureText: true,
              ),
              const SizedBox(height: 12.0),
              RoundedButtonPrimary(
                title: 'Log in',
                onPressed: () => sendEmailAndPassword(context),
              ),
              const SizedBox(height: 12.0),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: kAntiqueWhite,
                    textStyle: const TextStyle(fontSize: 16)),
                onPressed: () {
                  //TODO: forgot your password
                },
                child: const Text(
                  'Forgot your password?',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
