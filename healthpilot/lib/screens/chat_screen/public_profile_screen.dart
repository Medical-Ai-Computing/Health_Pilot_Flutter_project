import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthpilot/data/constants.dart';
import 'package:healthpilot/screens/chat_screen/similar_people_screen.dart';
import 'package:healthpilot/screens/chat_screen/widgets/custom_update_button.dart';
import 'package:healthpilot/widget/custom_app_bar_title.dart';

class PublicProfileScree extends StatelessWidget {
  const PublicProfileScree({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size(50, 60),
            child: CustomAppBar(
                title: 'Public Profile',
                leadingIcon: Icons.arrow_back_outlined)),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildHeaderText(),
        const SizedBox(
          height: 23,
        ),
        Align(child: _buildProfileAvatar()),
        const SizedBox(
          height: 12,
        ),
        Align(child: _buildUploadImageButton()),
        _buildAboutCard(),
        const SizedBox(
          height: 20,
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
      'Add some info you want people to see',
      style: TextStyle(
          color: const Color.fromRGBO(42, 42, 42, 1),
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.165),
    );
  }

  Widget _buildProfileAvatar() {
    return const Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(devsImage),
          radius: 45.5,
        ),
        Positioned(
            bottom: 3,
            right: 5,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Color.fromRGBO(42, 42, 42, 1),
            )),
      ],
    );
  }

  Widget _buildUploadImageButton() {
    return TextButton(
        onPressed: () {},
        child: Text(
          'Upload images',
          style: TextStyle(
              color: const Color.fromRGBO(42, 42, 42, 0.50),
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.165),
        ));
  }

  Widget _buildAboutCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: TextStyle(
              color: const Color.fromRGBO(42, 42, 42, 1),
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.165),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.25), width: 1)),
          color: const Color.fromRGBO(110, 182, 255, 0.1),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 20, 13, 48),
              child: Text(
                publicProfileAboutMe,
                style: TextStyle(
                    color: const Color.fromRGBO(42, 42, 24, 1),
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.sp,
                    height: 1.7,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.165),
              )),
        )
      ],
    );
  }
}
