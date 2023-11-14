import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthpilot/data/constants.dart';
import 'package:healthpilot/screens/on_boarding_screens/physical_therapy_screen.dart';

import 'package:healthpilot/screens/health_section/health_profile_screen.dart';
import 'package:healthpilot/screens/home_page_screen/home_page_screen.dart';

import 'screens/on_boarding_screens/physical_therapy_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HealthPilotApp());
}

class HealthPilotApp extends StatelessWidget {
  const HealthPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(411, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Health Pilot',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Roboto', // Example font family
            ),
            home: const WelcomeScreen(),
          );
        });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Pilot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Example font family
      ),
      home: const WelcomeScreen(), // commented before
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void goToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PhysicalTherapyScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    goToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Health Pilot'),
          ),
          body: const Center(child: Image(image: AssetImage(welcomeLogo)))),
    );
  }
}
