import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/common/widgets/rounded_button_primary.dart';
import 'package:bbk_final_ana/common/widgets/rounded_button_secondary.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/auth/screens/login_screen.dart';
import 'package:bbk_final_ana/auth/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = '/welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000));
    animationController.forward();
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBasicStructure(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Hero(
                      tag: kLogoTag,
                      child: Image.asset('assets/images/logo.png')),
                ),
                animation.value > 0.6
                    ? const Expanded(
                        flex: 2,
                        child: Text(
                          'Sabiá',
                          style: TextStyle(
                            fontSize: 60.0,
                            fontFamily: 'DancingScript',
                            color: kAntiqueWhite,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(height: 12.0),
            animation.value < 0.6
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20.0, height: 100.0),
                      const Text(
                        'Send',
                        style: TextStyle(
                          color: kBlackOlive,
                          fontSize: 48.0,
                          fontFamily: 'DancingScript',
                        ),
                      ),
                      const SizedBox(width: 12.0, height: 100.0),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 48.0,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w900,
                          color: kAntiqueWhite,
                          //fontFamily: 'Horizon',
                        ),
                        child: AnimatedTextKit(
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TypewriterAnimatedText('stories',
                                speed: const Duration(milliseconds: 200)),
                            TypewriterAnimatedText('love',
                                speed: const Duration(milliseconds: 200)),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      RoundedButtonPrimary(
                        title: 'Log in',
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                      RoundedButtonSecondary(
                        title: 'Sign up',
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
