import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_care/firebase_options.dart';
import 'package:tree_care/provider/history_provider.dart';
import 'package:tree_care/navigation/bottom_nav.dart';
import 'package:tree_care/navigation/home.dart';
import 'package:tree_care/scan/scan_screen_no_auth.dart';
import 'package:tree_care/services/network_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // Initialize network manager after app starts
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NetworkManager().init();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Tree Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: user == null ? const ScanScreenNoAuth() : const BottomNavBar(),
    );
  }
}
