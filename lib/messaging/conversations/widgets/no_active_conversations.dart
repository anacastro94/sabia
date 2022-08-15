import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';

class NoActiveConversationsMessage extends StatelessWidget {
  const NoActiveConversationsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60.0),
        const Text(
          'You don\'t have active conversations.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'DancingScript',
            fontSize: 42.0,
            color: kBlackOlive,
          ),
        ),
        const SizedBox(height: 12.0),
        const Text(
          'Say "hello" to one of your contacts. ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'DancingScript',
            fontSize: 42.0,
            color: kBlackOlive,
          ),
        ),
        const SizedBox(height: 12.0),
        Image.asset('assets/images/logo.png'),
      ],
    );
  }
}
