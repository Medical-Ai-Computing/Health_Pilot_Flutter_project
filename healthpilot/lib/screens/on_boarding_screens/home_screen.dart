import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';

class PhysicalTherapyScreen extends StatefulWidget {
  const PhysicalTherapyScreen({super.key});

  @override
  State<PhysicalTherapyScreen> createState() => _PhysicalTherapyScreenState();
}

class _PhysicalTherapyScreenState extends State<PhysicalTherapyScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 43.0,
            ).copyWith(top: 99),
            child: const Image(
              image: AssetImage(physicalTherapy),
            ),
          ),
          const SizedBox(
            height: 44.95,
          ),
          Container(
            width: 290,
            height: 61,
            child: const Text(
              'Consult with specialists about your health.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(42, 42, 42, 1),
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          Container(
            width: 290,
            height: 61,
            child: const Text(
              'Get access to our ranged health professionals and start feeling better.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(42, 42, 42, 0.5),
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                Container(
                  width: _currentPage == i ? 29 : 10,
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
          const SizedBox(
            height: 46,
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
