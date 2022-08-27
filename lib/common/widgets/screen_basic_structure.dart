import 'package:bbk_final_ana/common/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class ScreenBasicStructure extends StatelessWidget {
  const ScreenBasicStructure({
    Key? key,
    this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
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
