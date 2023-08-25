import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                  Slider(
                      value: _currentAge,
                      onChanged: (value) {
                        setState(() {
                          _currentAge = value;
                        });
                      }),
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
                        hint: Text(mesurementTypeForHeight!,
                          style: TextStyle(
                            color: Colors.grey
                          ),
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
                  Slider(
                      value: _currentAge,
                      onChanged: (value) {
                        setState(() {
                          _currentAge = value;
                        });
                      }),
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
                        hint: Text(mesurementTypeForWeight!,
                          style: TextStyle(
                              color: Colors.grey
                          ),
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
                  Slider(
                      value: _currentAge,
                      onChanged: (value) {
                        setState(() {
                          _currentAge = value;
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.only( top:48.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InitialInfoSecond()), // Navigate to the DestinationPage
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color.fromRGBO(110, 182, 255, 1),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.25,
                              vertical: MediaQuery.of(context).size.height * 0.02),
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
