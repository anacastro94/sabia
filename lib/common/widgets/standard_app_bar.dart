import 'package:flutter/material.dart';

import '../constants/constants.dart';

class StandardAppBar extends AppBar {
  StandardAppBar({super.key, this.onPressed, required this.titleName});
  final Function()? onPressed;
  final String titleName;

  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleName,
        style: const TextStyle(color: kAntiqueWhite),
      ),
      leading: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.chevron_left,
          color: kAntiqueWhite,
        ),
      ),
    );
  }
}
