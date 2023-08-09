import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/on_boarding_screens/physical_therapy_screen.dart';
import 'package:healthpilot/screens/on_boarding_screens/terms_and_conditions.dart';
import 'package:healthpilot/theme/app_theme.dart';
import 'package:healthpilot/screens/on_boarding_screens/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentPage = 0;
  bool _isSecurePassword = true;
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.fromLTRB(90, 70, 50, 20).copyWith(top: 99),
                child: const Image(
                  image: AssetImage(welcomeLogo),
                ),
              ),
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
            width: size.width * 0.705,
            height: size.height * 0.040,
            child: const Text(
              letsgetyou,
              textAlign: TextAlign.center,
              style: AppTheme.descriptionTextForSpecialistStyle,
            ),
          ),
          SizedBox(
            height: size.height * 0.009,
          ),
          Container(
            width: size.width * 0.805,
            height: size.height * 0.056,
            child: const Text(
                "By creating an account, unlock complete features and access personal data",
                textAlign: TextAlign.center,
                style: AppTheme.helperTextForUserStyle),
          ),
          SizedBox(
            height: size.height * 0.054,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.012,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            child: TextField(
              obscureText: _isSecurePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.key),
                border: OutlineInputBorder(),
                hintText: 'Password',
                suffixIcon: togglePassword(),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.012,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            child: TextField(
              obscureText: _isSecurePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.key),
                border: OutlineInputBorder(),
                hintText: 'Confirm Password',
                suffixIcon: togglePassword(),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.022,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
            child: Row(
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked = newBool;
                      });
                    }),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Text.rich(TextSpan(
                          text: "I have read and agree to the ",
                          style: AppTheme.simplenormalTextForUserStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: terms,
                              style: AppTheme.simpleblueTextForUserStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TermsScreen(),
                                  ),
                                ),
                            ),
                            TextSpan(
                                text: and,
                                style: AppTheme.simplenormalTextForUserStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: conditions,
                                    style: AppTheme.simpleblueTextForUserStyle,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => TermsScreen(),
                                        ),
                                      ),
                                  )
                                ])
                          ]))),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.022,
          ),
          GestureDetector(
            onTap: () {},
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
                'Sign up',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.042,
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
                  height: 30.0,
                  indent: 20.0,
                  endIndent: 20.0,
                )),
            Text(
              or,
              style: AppTheme.orTextForUserStyle,
            ),
            Expanded(
                child: Divider(
                  height: 30.0,
                  indent: 16.0,
                  endIndent: 20.0,
                )),
          ]),
          SizedBox(
            height: size.height * 0.012,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 244, 244),
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(image: NetworkImage(googlelogo)),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.012,
          ),
          Wrap(
            spacing: -145,
            children: [
              Container(
                width: size.width * 0.705,
                child: const Text(alreadyhave,
                    style: AppTheme.normalTextForUserStyle),
              ),
              GestureDetector(
                child: Text(login, style: AppTheme.blueTextForUserStyle),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          Wrap(
            spacing: -195,
            children: [
              Container(
                width: size.width * 0.705,
                child: const Text(giveitatry,
                    style: AppTheme.normalTextForUserStyle),
              ),
              GestureDetector(
                child: Text(skip, style: AppTheme.blueTextForUserStyle),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PhysicalTherapyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }

//password visibility condition
  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecurePassword = !_isSecurePassword;
          });
        },
        icon: _isSecurePassword
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off));
  }
}