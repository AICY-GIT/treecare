import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:tree_care/navigation/history.dart';
import 'package:tree_care/navigation/home.dart';
import 'package:tree_care/navigation/scan_screen_auth.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: const MainHome(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: 'Home',
            activeForegroundColor: Colors.black87,
            inactiveForegroundColor: Colors.black45,
          ),
        ),
        PersistentTabConfig(
          screen: const History(),
          item: ItemConfig(
            icon: const Icon(Icons.history),
            title: 'History',
            activeForegroundColor: Colors.black87,
            inactiveForegroundColor: Colors.black45,
          ),
        ),
        // IMPORTANT: this Scan is the *authenticated* version
        PersistentTabConfig(
          screen: const ScanScreenAuth(),
          item: ItemConfig(
            icon: const Icon(Icons.videocam),
            title: 'Scan',
            activeForegroundColor: Colors.black87,
            inactiveForegroundColor: Colors.black45,
          ),
        ),
        PersistentTabConfig(
          screen: const _LabelScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.label),
            title: 'Label',
            activeForegroundColor: Colors.black87,
            inactiveForegroundColor: Colors.black45,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style6BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: const Color(0xFFF2ECFA),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              offset: Offset(0, -1),
              blurRadius: 8,
            ),
          ],
        ),
        itemAnimationProperties: const ItemAnimation(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        ),
      ),
      stateManagement: true,
      resizeToAvoidBottomInset: true,
      handleAndroidBackButtonPress: true,
    );
  }
}

class _LabelScreen extends StatelessWidget {
  const _LabelScreen();
  @override
  Widget build(BuildContext context) => const _ScreenScaffold(title: 'Label');
}

class _ScreenScaffold extends StatelessWidget {
  final String title;
  const _ScreenScaffold({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FB),
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Screen',
            style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
