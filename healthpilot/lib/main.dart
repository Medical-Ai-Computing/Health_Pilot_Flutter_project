import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';

import 'package:healthpilot/screens/setup_personal_doctor/personal_information.dart'
    as doctor;

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
      // home: const SetupEmergencyContact(),
      // home: const PersonalInformation(),
      // home: const SetupPersonalDoctor(),
      // home: const HomePageScreen(),
      // home: const doctor.PersonalInformation(),
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
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePageScreen()),
      // );
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
