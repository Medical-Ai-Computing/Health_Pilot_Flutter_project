import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/on_boarding_screens/forgot_password.dart';
import 'package:healthpilot/screens/on_boarding_screens/physical_therapy_screen.dart';
import 'package:healthpilot/screens/on_boarding_screens/signup.dart';
import 'package:healthpilot/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _currentPage = 0;
  bool _isSecurePassword = true;

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
              loginGreeting,
              textAlign: TextAlign.center,
              style: AppTheme.descriptionTextForSpecialistStyle,
            ),
          ),
          SizedBox(
            height: size.height * 0.009,
          ),
          Container(
            width: size.width * 0.705,
            height: size.height * 0.056,
            child: const Text(loginInfo,
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
            height: size.height * 0.042,
          ),
          Wrap(
            spacing: -165,
            children: [
              Container(
                width: size.width * 0.705,
                child: const Text(forgotPassword,
                    style: AppTheme.normalTextForUserStyle),
              ),
              GestureDetector(
                child: Text(resetNow, style: AppTheme.blueTextForUserStyle),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.042,
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
                'Login',
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
            spacing: -165,
            children: [
              Container(
                width: size.width * 0.705,
                child: const Text(donthaveaccount,
                    style: AppTheme.normalTextForUserStyle),
              ),
              GestureDetector(
                child: Text(signup, style: AppTheme.blueTextForUserStyle),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
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