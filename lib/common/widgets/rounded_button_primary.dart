import 'package:flutter/material.dart';

import '../constants/constants.dart';

class RoundedButtonPrimary extends StatelessWidget {
  const RoundedButtonPrimary(
      {Key? key, this.color, required this.title, this.onPressed})
      : super(key: key);

  final Color? color;
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        elevation: 5.0,
        color: kDarkOrange,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          textColor: kAntiqueWhite,
          child: Text(
            title,
            style: kButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
