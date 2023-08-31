import 'package:flutter/material.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/home_page_screen.dart/home_page_screen.dart';
import 'package:healthpilot/theme/app_theme.dart';

class InitialInfoFinal extends StatefulWidget {
  const InitialInfoFinal({super.key});

  @override
  State<InitialInfoFinal> createState() => _InitialInfoFinal();
}

class _InitialInfoFinal extends State<InitialInfoFinal> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  // static Size size = const Size(0, 0);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 43.0,
        ).copyWith(top: 70),
        child: Image(
          height: 355,
          width: 355,
          image: const AssetImage(doctor),
        ),
      ),
      SizedBox(
        height: size.height * 0.052,
      ),
      SizedBox(
        width: size.width * 0.79,
        height: size.height * 0.103,
        child: const Text(initialInfoFinalTextTitle,
            textAlign: TextAlign.center,
            style: AppTheme.descriptionTextForInitalPage),
      ),
      SizedBox(
        width: size.width * 0.79,
        height: size.height * 0.0903,
        child: const Text(initialInfoFinalTextDescription,
            textAlign: TextAlign.center,
            style: AppTheme.helperTextForInitialStyle),
      ),
      SizedBox(
        height: size.height * 0.084,
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HomePageScreen()), // Navigate to the DestinationPage
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
            'Done',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    ]));
  }
}
