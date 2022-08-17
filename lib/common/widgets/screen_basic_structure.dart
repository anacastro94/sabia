import 'package:bbk_final_ana/common/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class ScreenBasicStructure extends StatelessWidget {
  const ScreenBasicStructure({
    Key? key,
    this.child,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  }) : super(key: key);

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      endDrawer: const DrawerMenu(),
      body: SafeArea(
        child: SizedBox(
          child: child,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
