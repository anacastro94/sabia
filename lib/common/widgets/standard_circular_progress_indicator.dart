import 'package:flutter/material.dart';

import '../constants/constants.dart';

class StandardCircularProgressIndicator extends StatelessWidget {
  const StandardCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      backgroundColor: kGreenLight,
      color: kDarkOrange,
    );
  }
}
