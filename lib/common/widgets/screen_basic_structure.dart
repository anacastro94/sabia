import 'package:flutter/material.dart';

class ScreenBasicStructure extends StatelessWidget {
  const ScreenBasicStructure({
    Key? key,
    this.child,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: child,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
