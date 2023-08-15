import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/contants.dart';
import '../../theme/app_theme.dart';

class DevsCard extends StatelessWidget {
  const DevsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: AppTheme.cardThemeForDevs.color,
      margin: EdgeInsets.all(size.width * 0.03),
      child: SizedBox(
        height: size.height * 0.5,
        width: size.width * 0.4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.04),
                  topRight: Radius.circular(size.width * 0.04)),
              child: Image(
                image: const AssetImage(devsImage),
                fit: BoxFit.cover,
                height: size.height * 0.2,
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            const Text('John Doe '),
            const Text(
              'Flutter Developer',
              style: AppTheme.helperTextForUserStyle,
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    //TODO:
                  },
                  child: SizedBox(
                    width: size.height * 0.02,
                    child: SvgPicture.asset(githubLogo),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO:
                  },
                  child: SvgPicture.asset(linkedinLogo),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO:
                  },
                  child: SizedBox(
                      width: size.height * 0.02,
                      child: SvgPicture.asset(gmailLogo)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
