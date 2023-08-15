import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/on_boarding_screens/login.dart';
import 'package:healthpilot/theme/app_theme.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});
  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Text("")],
        ),
      ),
    );
  }
}