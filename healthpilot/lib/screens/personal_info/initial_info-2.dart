import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/personal_info/initial_info-3.dart';

import '../../theme/app_theme.dart';

class InitialInfoSecond extends StatefulWidget {
  InitialInfoSecond({Key? key}) : super(key: key);

  @override
  State<InitialInfoSecond> createState() => _InitialInfoSecondState();
}

class _InitialInfoSecondState extends State<InitialInfoSecond> {
  String hypertensionAnswer = "";
  String accidentsAnswer = "";
  String smokingAnswer = "";
  String diabetesAnswer = "";
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
            'Almost There',
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 28.0, bottom: 28.0),
                child: buildQuestionWithRadioButtons(
                  "Do you suffer from hypertension?",
                  "hypertension",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: buildQuestionWithRadioButtons(
                  "Have you had any accidents recently?",
                  "accidents",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: buildQuestionWithRadioButtons(
                    "Do you smoke often?", "smoking"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: buildQuestionWithRadioButtons(
                    "Do you suffer from diabetes?", "diabetes"),
              ),
              SizedBox(height: 16.0),
              Text(
                "Summary of Answers:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
                  maxLines: 2,
              ),
              SizedBox(height: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hypertension:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Colors.black),
                          maxLines: 2,
                        ),
                        Text(" $hypertensionAnswer",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18, color: Color.fromRGBO(110, 182, 255, 1)),
                          maxLines: 2,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Accidents: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
                          maxLines: 2,),
                        Text("$accidentsAnswer",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18, color: Color.fromRGBO(110, 182, 255, 1)),
                          maxLines: 2,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Smoking: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
                          maxLines: 2,
                        ),
                        Text("$smokingAnswer",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18, color: Color.fromRGBO(110, 182, 255, 1)),
                          maxLines: 2,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Diabetes:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
                          maxLines: 2,),
                        Text("$diabetesAnswer",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18, color: Color.fromRGBO(110, 182, 255, 1)),
                          maxLines: 2,),
                      ],
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Set up later?",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black54),
                      maxLines: 2,),
                    Padding(
                      padding: const EdgeInsets.only( top:8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InitialInfoThird()), // Navigate to the DestinationPage
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
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildQuestionWithRadioButtons(String question, String questionKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
            maxLines: 2,
        ),
        Row(
          children: <Widget>[
            buildRadioButton("Yes", questionKey),
            buildRadioButton("No", questionKey),
            buildRadioButton("I don't know", questionKey),
          ],
        ),
      ],
    );
  }

  Widget buildRadioButton(String value, String questionKey) {
    return Row(
      children: <Widget>[
        Radio<String>(
          value: value,
          groupValue: getGroupValue(questionKey),
          onChanged: (String? newValue) {
            setState(() {
              setAnswer(questionKey, newValue);
            });
          },
        ),
        Text(value),
      ],
    );
  }

  String? getGroupValue(String questionKey) {
    switch (questionKey) {
      case "hypertension":
        return hypertensionAnswer;
      case "accidents":
        return accidentsAnswer;
      case "smoking":
        return smokingAnswer;
      case "diabetes":
        return diabetesAnswer;
      default:
        return null;
    }
  }

  void setAnswer(String questionKey, String? value) {
    switch (questionKey) {
      case "hypertension":
        hypertensionAnswer = value ?? "";
        break;
      case "accidents":
        accidentsAnswer = value ?? "";
        break;
      case "smoking":
        smokingAnswer = value ?? "";
        break;
      case "diabetes":
        diabetesAnswer = value ?? "";
        break;
    }
  }
}
