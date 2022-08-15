import 'package:flutter/material.dart';

import '../constants/constants.dart';

class RoundedButtonSecondary extends StatelessWidget {
  const RoundedButtonSecondary({Key? key, required this.title, this.onPressed})
      : super(key: key);

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        elevation: 5.0,
        color: kAntiqueWhite,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          textColor: kBlackOlive,
          child: Text(
            title,
            style: kButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
