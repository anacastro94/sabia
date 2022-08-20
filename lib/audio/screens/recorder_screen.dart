import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecorderScreen extends ConsumerStatefulWidget {
  const RecorderScreen({Key? key}) : super(key: key);
  static const String id = '/recorder';

  @override
  ConsumerState<RecorderScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<RecorderScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
