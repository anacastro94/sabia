import 'package:flutter/material.dart';

import '../constants/constants.dart';

class StandardCircularProfileAvatar extends StatelessWidget {
  const StandardCircularProfileAvatar({
    Key? key,
    this.radius = 42,
  }) : super(key: key);
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: kAntiqueWhite,
      backgroundImage: const AssetImage('assets/images/logo.png'),
    );
  }
}
