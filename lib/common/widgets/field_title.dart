import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FieldTitle extends StatelessWidget {
  const FieldTitle({
    Key? key,
    required this.title,
    this.fontColor = kBlackOlive,
  }) : super(key: key);
  final String title;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontFamily: 'DancingScript',
        fontSize: 30.0,
        color: fontColor,
      ),
    );
  }
}
