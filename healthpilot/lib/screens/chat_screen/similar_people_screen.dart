import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthpilot/widget/custom_app_bar_title.dart';

import '../../data/constants.dart';
import 'widgets/custom_update_button.dart';

class SimilarPeopleScreen extends StatelessWidget {
  const SimilarPeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(50, 60),
        child: CustomAppBar(
          onPressed: () {},
          title: 'Similar People',
          suffixIconImage: appBarTitleImage,
          leadingIcon: Icons.arrow_back_outlined,
        ),
      ),
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildHeaderText(),
        const SizedBox(
          height: 60,
        ),
        _buildImageBannerWithText(),
        const SizedBox(
          height: 80,
        ),
        Align(
            child: CustomUpdateButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimilarPeopleScreen(),
                      ));
                },
                title: 'Update Public Profile'))
      ]),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Connect with people like you',
      style: TextStyle(
          color: const Color.fromRGBO(42, 42, 42, 1),
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.165),
    );
  }

  Widget _buildImageBannerWithText() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color.fromRGBO(110, 182, 255, 1),
          Color.fromRGBO(110, 182, 255, 0.85),
          Color.fromRGBO(110, 182, 255, 0.25)
        ]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                child: Image.asset(devsImage,
                    height: 240, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 16,
                child: _buildWButtonOnBanner(
                    'Wants to connect', const Color.fromRGBO(42, 42, 42, 0.65)),
              ),
              Positioned(
                bottom: 24,
                right: 7,
                child: _buildWButtonOnBanner('98% Symptoms match',
                    const Color.fromRGBO(110, 182, 255, 1)),
              ),
              Positioned(
                bottom: 34,
                left: 11,
                child: _buildTextCardOnBanner(
                  'Amanda Haller,28',
                  16,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 11,
                child: _buildTextCardOnBanner(
                  'Suffers from Schizophrenia ',
                  12,
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 15, 12, 15),
              child: Text(
                similarPeopleAbout,
                style: TextStyle(
                    color: const Color.fromRGBO(42, 42, 42, 1),
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                    letterSpacing: -0.165),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(
                    Icons.close, () {}, const Color.fromRGBO(252, 34, 34, 1)),
                _buildIconButton(Icons.handshake_outlined, () {},
                    const Color.fromRGBO(110, 182, 255, 1)),
                _buildIconButton(Icons.messenger_outline, () {},
                    const Color.fromRGBO(76, 217, 100, 1)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, VoidCallback onPressed, Color iconColor) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: iconColor,
          )),
    );
  }

  Widget _buildWButtonOnBanner(String title, Color color) {
    return TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          minimumSize: const Size(109, 19),
          foregroundColor: Colors.transparent,
          backgroundColor: color,
        ),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontFamily: ' Plus Jakarta Sans',
              fontSize: 12.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.165),
        ));
  }

  Widget _buildTextCardOnBanner(String text, int fontSize) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Plus Jakarta Sans',
          fontSize: fontSize.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.165),
    );
  }
}
