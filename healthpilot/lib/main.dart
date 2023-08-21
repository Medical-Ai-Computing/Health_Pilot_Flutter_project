import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/on_boarding_screens/personal_information_screen.dart';

import 'package:healthpilot/screens/on_boarding_screens/physical_therapy_screen.dart';
import 'package:healthpilot/screens/on_boarding_screens/signup_and_login_screen.dart';

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
      home: const SignupAndLoginScreen(),
      routes: {
        ConfirmEmailScreen.routeName: ((context) => const ConfirmEmailScreen()),
        ForgotPasswordScreen.routeName: ((context) => ForgotPasswordScreen()),
        ForgotPasswordCheckEmail.routeName: (((context) =>
            const ForgotPasswordCheckEmail())),
        PaymentMethodScreen.routeName: (((context) =>
            const PaymentMethodScreen()))
      },
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
