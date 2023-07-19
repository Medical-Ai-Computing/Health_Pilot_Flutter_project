import 'package:flutter/material.dart';
import '/widget/custom_app_bar_title.dart';

import '../../data/constants.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  State<GetStartedScreen> createState() {
    return _GetStartedScreenState();
  }
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  double shapePointerValue = 25;

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
      body: const Center(
        child: Card(
          child: Text("Gets Started"),
        ),
      ),
    );
  }
}
