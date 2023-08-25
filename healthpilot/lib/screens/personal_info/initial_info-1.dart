import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/personal_info/initial_info-2.dart';

import '../../theme/app_theme.dart';

class InitialInfoFirst extends StatefulWidget {
  InitialInfoFirst({Key? key}) : super(key: key);

  @override
  State<InitialInfoFirst> createState() => _InitialInfoFirstState();
}

class _InitialInfoFirstState extends State<InitialInfoFirst> {
  double _currentAge = 0;
  double tickWidth = 1.0;
  int selectedAge = 18;
  int selectedWeight = 18;
  int selectedHeight = 18;
  RulerPickerController? _rulerPickerController;
  String selectedHeightUnit = 'cm';
  String selectedWeightUnit = 'kg';
  String? mesurementTypeForWeight = "kg";
  List listItemsForWeight = ["kg", "gm"];
  String? mesurementTypeForHeight = "cm";
  List listItemsForHeight = ["cm", "ft"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(110, 182, 255, 1)),
            onPressed: () {
              // Define the action when the back button is pressed
              // Navigator.pop(context);
            },
            style: AppTheme.buttonStyleForAppBarBackButto,
          ),
          title: const Text(
            "Let's Get Started",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
            maxLines: 2,
          ),
          actions: [
            SvgPicture.asset(transalteIcon),
            const SizedBox(
              width: 30,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(28.0),
                child: Text(
                  "Choose your gender",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: ClipRRect(
                          child: Image.asset(
                            height: 134,
                            width: 99,
                            maleForinital,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: ClipRRect(
                          child: Image.asset(
                            height: 134,
                            width: 99,
                            femaleForinital,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: ClipRRect(
                          child: Image.asset(
                            height: 24,
                            width: 24,
                            brainfuck,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 28.0, top: 28, bottom: 28),
                        child: Text(
                          "Age",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: RulerPicker(
                      ranges: [
                        RulerRange(begin: 0, end: 10, scale: 0.1),
                        RulerRange(begin: 10, end: 100, scale: 1),
                        RulerRange(begin: 100, end: 1000, scale: 10),
                        RulerRange(begin: 1000, end: 10000, scale: 100),
                        RulerRange(begin: 10000, end: 100000, scale: 1000)
                      ],
                      controller: _rulerPickerController,
                      // beginValue: 0,
                      // endValue: 100,
                      // initValue: _rulerPickerController!.value,

                      rulerScaleTextStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(42, 42, 42, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500), //
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1.5,
                            height: 20,
                            scale: 0),
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1,
                            height: 15,
                            scale: 5),
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1,
                            height: 10,
                            scale: -1)
                      ],
                      onValueChanged: (num value) {
                        setState(() {
                          selectedAge = value.toInt();
                        });
                      },
                      width: MediaQuery.of(context).size.width * 1,
                      height: 40,
                      rulerMarginTop: 15,

                      onBuildRulerScaleText: (int index, num rulerScaleValue) {
                        return rulerScaleValue.toInt().toString();
                      },
                      // onBuildRulerScaleText: (int index, num rulerScaleValue) {  },
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: ClipRRect(
                          child: Image.asset(
                            height: 34,
                            width: 30,
                            height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 28.0, top: 28, bottom: 28),
                        child: Text(
                          "Height",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                          ),
                        ),
                      ),
                      DropdownButton(
                        hint: Text(
                          mesurementTypeForHeight!,
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: mesurementTypeForHeight,
                        onChanged: (newValue) {
                          setState(() {
                            mesurementTypeForHeight = newValue! as String?;
                          });
                        },
                        items: listItemsForHeight.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: RulerPicker(
                      ranges: [
                        RulerRange(begin: 0, end: 10, scale: 0.1),
                        RulerRange(begin: 10, end: 100, scale: 1),
                        RulerRange(begin: 100, end: 1000, scale: 10),
                        RulerRange(begin: 1000, end: 10000, scale: 100),
                        RulerRange(begin: 10000, end: 100000, scale: 1000)
                      ],
                      controller: _rulerPickerController,
                      // beginValue: 0,
                      // endValue: 100,
                      // initValue: _rulerPickerController!.value,

                      rulerScaleTextStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(42, 42, 42, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500), //
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1.5,
                            height: 20,
                            scale: 0),
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1,
                            height: 15,
                            scale: 5),
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1,
                            height: 10,
                            scale: -1)
                      ],
                      onValueChanged: (num value) {
                        setState(() {
                          selectedAge = value.toInt();
                        });
                      },
                      width: MediaQuery.of(context).size.width * 1,
                      height: 40,
                      rulerMarginTop: 15,

                      onBuildRulerScaleText: (int index, num rulerScaleValue) {
                        return rulerScaleValue.toInt().toString();
                      },
                      // onBuildRulerScaleText: (int index, num rulerScaleValue) {  },
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: ClipRRect(
                          child: Image.asset(
                            height: 34,
                            width: 30,
                            weight,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 28.0, top: 28, bottom: 28),
                        child: Text(
                          "Weight",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                          ),
                        ),
                      ),
                      DropdownButton(
                        hint: Text(
                          mesurementTypeForWeight!,
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: mesurementTypeForWeight,
                        onChanged: (newValue) {
                          setState(() {
                            mesurementTypeForWeight = newValue! as String?;
                          });
                        },
                        items: listItemsForWeight.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: RulerPicker(
                      ranges: [
                        RulerRange(begin: 0, end: 10, scale: 0.1),
                        RulerRange(begin: 10, end: 100, scale: 1),
                        RulerRange(begin: 100, end: 1000, scale: 10),
                        RulerRange(begin: 1000, end: 10000, scale: 100),
                        RulerRange(begin: 10000, end: 100000, scale: 1000)
                      ],
                      controller: _rulerPickerController,
                      // beginValue: 0,
                      // endValue: 100,
                      // initValue: _rulerPickerController!.value,

                      rulerScaleTextStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(42, 42, 42, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500), //
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1.5,
                            height: 20,
                            scale: 0),
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1,
                            height: 15,
                            scale: 5),
                        ScaleLineStyle(
                            color: Color.fromRGBO(42, 42, 42, 1),
                            width: 1,
                            height: 10,
                            scale: -1)
                      ],
                      onValueChanged: (num value) {
                        setState(() {
                          selectedAge = value.toInt();
                        });
                      },
                      width: MediaQuery.of(context).size.width * 1,
                      height: 40,
                      rulerMarginTop: 15,
                      onBuildRulerScaleText: (int index, num rulerScaleValue) {
                        return rulerScaleValue.toInt().toString();
                      },
                      // onBuildRulerScaleText: (int index, num rulerScaleValue) {  },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 48.0, bottom: 48),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InitialInfoSecond()), // Navigate to the DestinationPage
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(110, 182, 255, 1),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.25,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
