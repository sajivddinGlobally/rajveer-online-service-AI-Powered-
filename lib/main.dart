import 'dart:developer';
import 'dart:io';
import 'package:ai_powered_app/core/utils/globalroute.key.dart';
import 'package:ai_powered_app/screen/firbaseOptions.dart';
import 'package:ai_powered_app/screen/jobs.screen/home.screen.dart';
import 'package:ai_powered_app/screen/matrimony.screen/home.page.dart';
import 'package:ai_powered_app/screen/realEstate/realEstate.home.page.dart';
import 'package:ai_powered_app/screen/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides(); // ⚠️ Only for dev/test
  try {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen('userdata')) {
      await Hive.openBox('userdata');
    }
  } catch (e) {
    log("Hive initialization failed: $e");
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rajveer Online Services',
            navigatorKey: navigatorKey,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const AuthCheck(),
          );
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});
  Future<String?> _getInitialScreen() async {
    final box = Hive.box('userdata');
    final type = box.get('type');
    final token = box.get('token');
    if (token != null && type == "JOBS") {
      return 'job'; // Navigate to job screen
    } else if (token != null && type == "REAL ESTATE") {
      return 'REAL ESTATE'; // Navigate to normal user screen
    } else if (token != null && type == "MATRIMONY") {
      return 'MATRIMONY'; // Navigate to normal user screen
    } else {
      return 'splash'; // Not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }
        final screen = snapshot.data;
        if (screen == 'job') {
          return const HomeScreen(); // ✅ Replace with your actual job screen
        } else if (screen == 'MATRIMONY') {
          return const HomePage(); // ✅ Normal user screen
        } else if (screen == 'REAL ESTATE') {
          return const RealestateHomePage(); // ✅ Normal user screen
        } else {
          return const SplashPage(); // ✅ Not logged in
        }
      },
    );
  }
}
