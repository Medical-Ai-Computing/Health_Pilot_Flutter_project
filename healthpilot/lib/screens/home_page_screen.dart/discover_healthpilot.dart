import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

import '../../data/contants.dart';
import '../../theme/app_theme.dart';

class DiscoverHealthpilot extends StatelessWidget {
  const DiscoverHealthpilot({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
        margin: EdgeInsets.all(size.width * 0.06),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * 0.02),
              gradient: AppTheme.cardThemeForHomeScreenOverview.gradient),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                margin: EdgeInsets.only(left: size.height * 0.03),
                width: size.width * 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: Image(
                        image: AssetImage(welcomeLogo),
                        height: size.height * 0.03,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    const Text(
                      'Take a quick tour on what Health Pilot can do to simplify your life.',
                      textAlign: TextAlign.left,
                      style: AppTheme.homePageOverviewUnitTextStyle,
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        Icon(
                          LineIcons.clock,
                          size: size.height * 0.025,
                          color: AppTheme.helperTextForUserStyle.color,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                          height: size.height * 0.05,
                        ),
                        const Text(
                          '3-5 mins',
                          style: AppTheme.helperTextForUserStyle,
                        )
                      ],
                    ),
                    Row(children: [
                      const Text('Let\'s begin',
                          style: AppTheme.homePageOverviewUnitTextStyle),
                      Icon(
                        LineIcons.arrowRight,
                        size: AppTheme.homePageOverviewUnitTextStyle.fontSize,
                      )
                    ])
                  ],
                ),
              ),
              Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [SvgPicture.asset(dicoverHelthBotSvg)],
                  )),
            ],
          ),
        ));
  }
}
