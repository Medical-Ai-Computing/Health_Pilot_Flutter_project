import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/theme/app_theme.dart';
import 'package:line_icons/line_icons.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final String overviewResult;
  final String overviewUnit;
  const OverviewCard(
      {required this.icon,
      required this.overviewResult,
      required this.overviewUnit});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.02),
            gradient: AppTheme.cardThemeForHomeScreenOverview.gradient),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.width * 0.01, horizontal: size.width * 0.03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: size.height * 0.004,
                  right: size.height * 0.01,
                ),
                child: Icon(
                  icon,
                  size: size.width * 0.06,
                ),
              ),
              Column(children: [
                Text(
                  overviewResult,
                  style: AppTheme.homePageOverviewResultTextStyle,
                ),
                Text(
                  overviewUnit,
                  style: AppTheme.homePageOverviewUnitTextStyle,
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
