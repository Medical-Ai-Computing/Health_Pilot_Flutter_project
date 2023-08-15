import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/on_boarding_screens/login.dart';
import 'package:healthpilot/theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                elevation: 2.0,
                fillColor: Color.fromARGB(255, 218, 238, 252),
                child: Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(110, 182, 255, 1),
                  size: 20.0,
                ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 100, 100)
                      .copyWith(top: 99),
                  child: Text(
                    forgotpassword,
                    style: AppTheme.descriptionTextForSpecialistStyle,
                  )),
              Icon(
                Icons.translate,
                color: Colors.black,
                size: 20.0,
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.040,
          ),
          Container(
            width: size.width * 0.605,
            height: size.height * 0.285,
            child: const Image(
              height: 450,
              width: 400,
              image: AssetImage(checkemail),
            ),
          ),
          SizedBox(
            height: size.height * 0.009,
          ),
          Container(
            width: size.width * 0.705,
            height: size.height * 0.036,
            child: const Text(checkEmail,
                textAlign: TextAlign.center,
                style: AppTheme.descriptionTextForSpecialistStyle),
          ),
          SizedBox(
            height: size.height * 0.029,
          ),
          Container(
            width: size.width * 0.705,
            height: size.height * 0.176,
            child: const Text(
                "We've emailed you instructions on how to change your password. Please check your inbox.",
                textAlign: TextAlign.center,
                style: AppTheme.helperTextForUserStyle),
          ),
          Container(
            width: size.width * 0.705,
            height: size.height * 0.026,
            child: const Text("Didn't receive an email?",
                textAlign: TextAlign.center,
                style: AppTheme.descriptionNormalTextForSpecialistStyle),
          ),
          SizedBox(
            height: size.height * 0.024,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: 231,
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(110, 182, 255, 1),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(10, 10),
                ),
              ),
              child: const Text(
                'Return to login',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}