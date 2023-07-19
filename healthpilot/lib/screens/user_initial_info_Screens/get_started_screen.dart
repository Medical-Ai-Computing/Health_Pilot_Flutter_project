import 'package:flutter/material.dart';
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
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAge = index + 1;
                    });
                  },
                  child: SizedBox(
                    height: 40,
                    width: 22,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        selectedAge == index + 1
                            ? Container(
                                alignment: Alignment.topLeft,
                                height: 10,
                                width: 30,
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromRGBO(110, 182, 255, 1),
                                ),
                              )
                            : const Text(''),
                        SizedBox(
                          width: tickWidth,
                          height: (index + 1) % 5 == 0 || index == 0 ? 15 : 10,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, innerIndex) {
                                return Container(
                                  width: tickWidth,
                                  color: selectedAge == index + 1
                                      ? const Color.fromRGBO(110, 182, 255, 1)
                                      : const Color.fromRGBO(42, 42, 42, 1),
                                );
                              },
                              separatorBuilder: (context, innerIndex) {
                                return const SizedBox(
                                  width: 1,
                                );
                              },
                              itemCount: 1),
                        ),
                        Text(
                          index == 0
                              ? (index + 1).toString()
                              : (index + 1) % 5 == 0
                                  ? ((index + 1)).toString()
                                  : '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedAge == index + 1
                                ? const Color.fromRGBO(110, 182, 255, 1)
                                : const Color.fromRGBO(42, 42, 42, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAge = index + 1;
                    });
                  },
                  child: SizedBox(
                    height: 40,
                    width: 22,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        selectedAge == index + 1
                            ? Container(
                                alignment: Alignment.topLeft,
                                height: 10,
                                width: 30,
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromRGBO(110, 182, 255, 1),
                                ),
                              )
                            : const Text(''),
                        SizedBox(
                          width: tickWidth,
                          height: (index + 1) % 5 == 0 || index == 0 ? 15 : 10,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, innerIndex) {
                                return Container(
                                  width: tickWidth,
                                  color: selectedAge == index + 1
                                      ? const Color.fromRGBO(110, 182, 255, 1)
                                      : const Color.fromRGBO(42, 42, 42, 1),
                                );
                              },
                              separatorBuilder: (context, innerIndex) {
                                return const SizedBox(
                                  width: 1,
                                );
                              },
                              itemCount: 1),
                        ),
                        Text(
                          index == 0
                              ? (index + 1).toString()
                              : (index + 1) % 5 == 0
                                  ? ((index + 1)).toString()
                                  : '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedAge == index + 1
                                ? const Color.fromRGBO(110, 182, 255, 1)
                                : const Color.fromRGBO(42, 42, 42, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
