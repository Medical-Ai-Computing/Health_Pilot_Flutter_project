import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/home_page_screen.dart/home_page_screen.dart';
import 'package:healthpilot/screens/meet_the_devs_screen/meet_the_devs.dart';
import 'package:healthpilot/screens/on_boarding_screens/physical_therapy_screen.dart';
import 'package:healthpilot/screens/personal_info/initial_info-1.dart';
import 'package:healthpilot/screens/personal_info/initial_info-2.dart';
import 'package:healthpilot/screens/personal_info/initial_info-3.dart';
import 'package:healthpilot/screens/personal_info/initial_info-4.dart';
import 'package:healthpilot/screens/setup_emergency_contact/personal_information.dart';
import 'package:healthpilot/screens/setup_emergency_contact/setup_emergency_contact.dart';

import 'screens/on_boarding_screens/physical_therapy_screen.dart';

void main() {
  runApp(const HealthPilotApp());
}

class HealthPilotApp extends StatelessWidget {
  const HealthPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Pilot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Example font family
      ),
      home: InitialInfoFirst(),
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
