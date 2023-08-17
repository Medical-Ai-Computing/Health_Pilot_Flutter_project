import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_theme.dart';

class AdWidget extends StatefulWidget {
  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  // const AdWidget({super.key});
  final _pageController = PageController();

  int _currentPage = 0;
  List<String> ads = [
    'Place Ad one Here',
    'Place Ad two Here',
    'Place Ad three Here',
  ];
  void changeAdPage() {
    // Future.delayed(
    //   Duration(seconds: 5),
    //   () {
    //     if (_currentPage >= ads.length) {
    //       _currentPage = 0;
    //     }
    setState(() {
      _currentPage++;
    });
    // },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.2,
      decoration: AppTheme.cardThemeForHomeScreenOverview,
      child: PageView.builder(
        controller: _pageController,
        itemCount: ads.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) => GestureDetector(
          onHorizontalDragCancel: () => changeAdPage(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  ads[_currentPage],
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < ads.length; i++)
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        height: size.height * 0.0118,
                        width: _currentPage == i
                            ? size.width * 0.05
                            : size.width * 0.025,
                        // color: Color.fromRGBO(110, 182, 255, 1),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(100, 100)),
                          color: Color.fromRGBO(110, 182, 255, 1),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
