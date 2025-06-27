import 'package:flutter/material.dart';
import 'package:money_tracker_new/presentation/widget/app_bar.dart'; // pastikan path sesuai

class MasterLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? bottomNavigationBar;

  const MasterLayout({
    super.key,
    this.appBar,
    required this.child,
    this.bottomNavigationBar,
  });

  @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    resizeToAvoidBottomInset: false, // <-- tambahkan ini
    backgroundColor: Colors.transparent,
    appBar: appBar ?? const AppbarCustom(),
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.webp',
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    ),
    bottomNavigationBar: bottomNavigationBar,
  );
}

}
