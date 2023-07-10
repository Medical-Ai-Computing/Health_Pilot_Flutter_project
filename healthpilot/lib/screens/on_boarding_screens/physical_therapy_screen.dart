import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/theme/app_theme.dart';

class PhysicalTherapyScreen extends StatefulWidget {
  const PhysicalTherapyScreen({super.key});

  @override
  State<PhysicalTherapyScreen> createState() => _PhysicalTherapyScreenState();
}

class _PhysicalTherapyScreenState extends State<PhysicalTherapyScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Health Pilot'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 43.0,
            ).copyWith(top: 99),
            child: const Image(
              image: AssetImage(physicalTherapy),
            ),
          ),
          SizedBox(
            height: size.height * 0.059,
          ),
          Container(
            width: size.width * 0.705,
            height: size.height * 0.072,
            child: const Text(descriptionTextForSpecialist,
                textAlign: TextAlign.center,
                style: AppTheme.descriptionTextForSpecialistStyle),
          ),
          SizedBox(
            height: size.height * 0.026,
          ),
          Container(
            width: size.width * 0.705,
            height: size.height * 0.072,
            child: const Text(helperTextForUser,
                textAlign: TextAlign.center,
                style: AppTheme.helperTextForUserStyle),
          ),
          SizedBox(
            height: size.height * 0.026,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                Container(
                  width: _currentPage == i
                      ? size.width * 0.07
                      : size.width * 0.024,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(50, 50)),
                    color: _currentPage == i
                        ? const Color.fromRGBO(110, 182, 255, 1)
                        : const Color.fromRGBO(110, 182, 255, 0.25),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: size.height * 0.054,
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
                'Next',
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
