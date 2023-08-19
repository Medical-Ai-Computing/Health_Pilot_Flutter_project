import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthpilot/theme/app_theme.dart';

class BlogRecomendationCard extends StatelessWidget {
  final String img;
  final String title;
  final String description;
  BlogRecomendationCard(
      {required this.img, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: size.width * 0.05),
      // padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
      width: size.width * 0.5,
      child: Column(
        children: [
          Card(
            child: Container(
              height: size.height * 0.15,
              width: double.infinity,
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                  gradient: AppTheme.cardThemeForHomeScreenOverview.gradient),
              child: SvgPicture.asset(img),
            ),
          ),
          Container(
            padding: EdgeInsets.all(
              size.width * 0.02,
            ),
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: size.width * 0.02,
            ),
            width: double.infinity,
            child: Text(
              description,
              style: AppTheme.blogDescriptionForBlogReccomdation,
            ),
          )
        ],
      ),
    );
  }
}
