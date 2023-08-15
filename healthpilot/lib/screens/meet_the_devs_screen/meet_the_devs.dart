import 'package:flutter/material.dart';
import 'package:healthpilot/screens/meet_the_devs_screen/devs_card.dart';

import '../../theme/app_theme.dart';

class MeetTheDevs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              // Define the action when the back button is pressed
              Navigator.pop(context);
            },
            style: AppTheme.buttonStyleForAppBarBackButto,
          ),
          title: const Text(
            'Meet The Developers',
          ),
        ),
        body: SafeArea(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: size.height * 0.35),
            itemBuilder: (context, index) => const DevsCard(),
            itemCount: 10, // itemCount: 10,for test added
          ),
        ));
  }
}
