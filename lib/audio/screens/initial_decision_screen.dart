import 'package:bbk_final_ana/audio/screens/library_screen.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/rounded_button_primary.dart';
import '../../common/widgets/rounded_button_secondary.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import '../../screens/home_screen.dart';

class InitialDecisionScreen extends StatelessWidget {
  const InitialDecisionScreen({Key? key}) : super(key: key);
  static const String id = '/initial-decision';

  @override
  Widget build(BuildContext context) {
    return ScreenBasicStructure(
      appBar: AppBar(
        backgroundColor: kGreenOlivine,
        elevation: 0.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'What would you like to do today?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kBlackOlive,
                fontSize: 48.0,
                fontFamily: 'DancingScript',
              ),
            ),
            const SizedBox(height: 24.0),
            Column(
              children: [
                RoundedButtonPrimary(
                  title: 'Listen to a story',
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.id);
                  },
                ),
                RoundedButtonSecondary(
                  title: 'Record a story',
                  onPressed: () {
                    Navigator.pushNamed(context, LibraryScreen.id);
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
