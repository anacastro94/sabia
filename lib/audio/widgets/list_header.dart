import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: kBlackOlive,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
