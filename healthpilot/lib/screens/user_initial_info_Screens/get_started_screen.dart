import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import '/widget/custom_app_bar_title.dart';

import '../../data/constants.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() {
    return _GetStartedScreenState();
  }
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  double tickWidth = 1.0;
  int selectedAge = 18;
  RulerPickerController? _rulerPickerController;
  int currentValue = 18;
  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: CustomAppBarTitle(
          title: letsStartAppBarTitle,
          leadingIcon: Icons.arrow_back_rounded,
          suffixIconImage: appBarTitleImage,
          onPressed: () {},
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30),
            width: 220,
            height: 22,
            child: const Text(
              'Choose your gender',
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans'),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/male.png'),
                  height: 100,
                  width: 71,
                ),
                Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/female.png'),
                  height: 100,
                  width: 98,
                )
              ]),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/age_icon.png'),
                  height: 24,
                  width: 24,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('Age',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Plus Jakarta Sans'))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: RulerPicker(
              controller: _rulerPickerController,
              beginValue: 0,
              endValue: 100,
              initValue: currentValue,
              // onBuildRulerScalueText: (index, rulerScaleValue) {
              //   print('rulerScaleValue:$rulerScaleValue');
              //   print('index:$index');
              //   return index.toString();
              // },
              rulerScaleTextStyle: TextStyle(
                  color: currentValue == _rulerPickerController!.value
                      ? Colors.amber
                      : Colors.grey),
              rulerBackgroundColor: Colors.grey.shade200,
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: Colors.grey, width: 1.5, height: 30, scale: 0),
                ScaleLineStyle(
                    color: Colors.red, width: 1, height: 25, scale: 5),
                ScaleLineStyle(
                    color: Colors.green, width: 1, height: 15, scale: -1)
              ],
              onValueChange: (value) {
                setState(() {
                  currentValue = value;
                });
                print('currentValue:$currentValue');
                print('value:${_rulerPickerController!.value}');
              },
              width: MediaQuery.of(context).size.width * 1,
              height: 80,
              rulerMarginTop: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/height_icon.png'),
                  height: 24,
                  width: 24,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('Height',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Plus Jakarta Sans'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
