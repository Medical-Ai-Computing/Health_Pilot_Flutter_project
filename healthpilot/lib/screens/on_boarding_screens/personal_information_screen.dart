// This Flutter screen allows users to enter and manage their personal information./// It includes fields for first name, last name, email, and phone number.
/// Users can also set up emergency contacts, personal doctor, and nutrition tracking.
// class PersonalInformationScreen extends StatefulWidget {
//   // ... (widget constructor and state creation)
// }

// /// The state class for the PersonalInformationScreen widget.
// class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
//   // ... (state variables and UI building logic)
// }

// /// A reusable widget for input fields like first name, last name, and email.
// class InputFields extends StatelessWidget {
//   // ... (constructor and UI building logic for input fields)
// }

/// A reusable widget for the phone number input field using the IntlPhoneField package.
// //class PhoneInputFields extends StatelessWidget {
//   // ... (constructor and UI building logic for phone input fields)
// }

/// A custom card widget that displays subscription-related information.
// c//lass SubscriptionCard extends StatefulWidget {
//   // ... (constructor and state creation for subscription card)
// }

/// The state class for the SubscriptionCard widget.
// class _SubscriptionCardState extends State<SubscriptionCard> {
//   // ... (UI building logic for subscription card)
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool _isPersonalDoctorSubscribed = false;

  bool _isNutritionTrackingSubscribed = false;

  void showAlertDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Adjust the radius as needed
            ),
            title: const Text(
              "Premium Feature",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Plus Jakarta Sans",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.165,
              ),
            ),
            content: const Text(
              "This feature is only available to premium users. To access this feature please upgrade to a premium subscription",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Plus Jakarta Sans",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.165,
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(110, 182, 255, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Container(
                      width: 100,
                      height: 28,
                      alignment: Alignment.center,
                      child: const Text(
                        "Subscribe",
                        style: TextStyle(
                          fontFamily: "Plus Jakarta Sans",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final screenWidth = size.width;
            final screenHeight = size.height;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.04,
                          screenHeight * 0.02,
                          0,
                          0,
                        ),
                        child: Container(
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(110, 182, 255, 0.25),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back),
                            color: const Color.fromRGBO(110, 182, 255, 1),
                            iconSize: screenWidth * 0.055,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.05,
                          screenHeight * 0.03,
                          0,
                          0,
                        ),
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            fontFamily: "PlusJakartaSans",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.04,
                          left: screenWidth * 0.2,
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.04,
                          height: screenWidth * 0.04,
                          child: SvgPicture.asset(
                            'assets/images/Vector.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.15),
                          child: const Image(
                            image: AssetImage(
                              'assets/images/personel.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.04),
                              color: Colors.white),
                          child: const Icon(
                            Icons.edit_square,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Text(
                      "Upload your profile photo",
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * 0.041,
                        color: const Color.fromRGBO(42, 42, 42, 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  InputFields(
                    label: "FirstName",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  InputFields(
                    label: "LastName",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  InputFields(
                    label: "Email",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  PhoneInputFields(
                    label: "Phone Number",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    keyboardType: TextInputType.phone,
                  ),
                  SubscriptionCard(
                    screenWidth: screenWidth,
                    title: "Set up your Emergency Contacts",
                    description:
                        "Start setting up your personal doctor to send health reports and various features.",
                    icon: null,
                    buttontxt: "Start setup",
                    subscription: showAlertDialogue,
                  ),
                  SubscriptionCard(
                    screenWidth: screenWidth,
                    title: "Set up your  personal doctor",
                    description: _isPersonalDoctorSubscribed
                        ? "Start setting up your personal doctor to send health reports and various features."
                        : "This feature is only available to premium subscribers. Subscribe to HealthPilot Premium to gain access.",
                    icon: _isPersonalDoctorSubscribed
                        ? null
                        : Icons.lock_outlined,
                    buttontxt: _isPersonalDoctorSubscribed
                        ? "Start setup"
                        : "Subscribe",
                    subscription: () {
                      setState(() {
                        _isPersonalDoctorSubscribed =
                            !_isPersonalDoctorSubscribed;
                      });
                    },
                  ),
                  SubscriptionCard(
                    screenWidth: screenWidth,
                    title: "Set up food and nutrition tracking",
                    description: _isNutritionTrackingSubscribed
                        ? "Start setting up your food and nutrition tracking to keep hold of your data on what u eat and drink."
                        : "This feature is only available to premium subscribers. Subscribe to HealthPilot Premium to gain access.",
                    icon: _isNutritionTrackingSubscribed
                        ? null
                        : Icons.lock_outlined,
                    buttontxt: _isNutritionTrackingSubscribed
                        ? "Start setup"
                        : "Subscribe",
                    subscription: () {
                      setState(() {
                        _isNutritionTrackingSubscribed =
                            !_isNutritionTrackingSubscribed;
                      });
                    },
                  ),
                  Container(
                    width: 231,
                    height: 47,
                    margin: const EdgeInsets.only(
                        top: 35, left: 23, bottom: 25, right: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(110, 182, 255, 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class InputFields extends StatelessWidget {
  final String label;
  final double screenWidth;
  final double screenHeight;
  final TextInputType keyboardType;

  const InputFields(
      {super.key,
      required this.label,
      required this.screenWidth,
      required this.screenHeight,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontFamily: "PlusJakartaSans",
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: 45,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide()),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0, // No vertical padding
                    horizontal: screenWidth * 0.04,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneInputFields extends StatelessWidget {
  final String label;
  final double screenWidth;
  final double screenHeight;
  final TextInputType keyboardType;

  const PhoneInputFields({
    super.key,
    required this.label,
    required this.screenWidth,
    required this.screenHeight,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontFamily: "PlusJakartaSans",
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 67, // Set a fixed height for the SizedBox
            child: IntlPhoneField(
              dropdownIconPosition: IconPosition.trailing,
              disableLengthCheck: false,
              initialCountryCode: 'ET',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide()),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatefulWidget {
  final double screenWidth;
  final String title; // Add explicit type
  final String description; // Add explicit type
  final IconData? icon; // Add explicit type
  final String buttontxt;
  final VoidCallback subscription;

  const SubscriptionCard(
      {Key? key,
      required this.screenWidth,
      required this.title,
      required this.description,
      required this.icon,
      required this.buttontxt,
      required this.subscription})
      : super(key: key);

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 7, right: 8),
      child: Container(
        width: widget.screenWidth * 0.9,
        height: 167,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(110, 182, 255, 0.3),
              Color.fromRGBO(110, 182, 255, 0.26),
              Color.fromRGBO(110, 182, 255, 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13, left: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: "PlusJakartaSans",
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16), // Add right padding
                    child: Icon(widget.icon),
                  ), // Removed unnecessary 'as IconData?'
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 13,
                left: 9,
              ),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: SizedBox(
                  width: 110,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: widget.subscription,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(110, 182, 255, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Text(
                      widget.buttontxt,
                      style: const TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
