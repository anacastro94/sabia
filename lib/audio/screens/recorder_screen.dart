import 'package:bbk_final_ana/audio/controller/recorder_controller.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../widgets/recorder_ui.dart';

class RecorderScreen extends ConsumerStatefulWidget {
  const RecorderScreen({Key? key}) : super(key: key);
  static const String id = '/recorder';

  @override
  ConsumerState<RecorderScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<RecorderScreen> {
  late RecorderController _recorderController =
      ref.watch(recorderControllerProvider);

  @override
  void initState() {
    super.initState();
    initializeIntlPackage();
  }

  @override
  void didChangeDependencies() {
    _recorderController = ref.watch(recorderControllerProvider);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _recorderController.disposeRecorder();
    super.dispose();
  }

  void initializeIntlPackage() async {
    await initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return ScreenBasicStructure(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.34,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.56,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
                color: kGreenLight.withOpacity(0.8),
              ),
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 240.0,
                  child: Image.asset('assets/images/bottom_decoration3.png')),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.6,
            child: const RecorderUI(),
          ),
        ],
      ),
    );
  }
}
