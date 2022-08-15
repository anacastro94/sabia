import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBasicStructure(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Sabiá',
                  style: TextStyle(
                    fontSize: 60.0,
                    fontFamily: 'DancingScript',
                    color: kAntiqueWhite,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          const CircularProgressIndicator(
            backgroundColor: kAntiqueWhite,
            color: kDarkOrange,
          ),
        ],
      ),
    );
  }
}
