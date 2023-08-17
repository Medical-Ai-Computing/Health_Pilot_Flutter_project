import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthpilot/screens/home_page_screen.dart/discover_healthpilot.dart';
import 'package:line_icons/line_icons.dart';
import '/screens/home_page_screen.dart/overview_card.dart';
import 'package:healthpilot/theme/app_theme.dart';

import '../../data/contants.dart';
import 'ad_widget.dart';
import 'blog_reccomendation._card.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // const HomePageScreen({super.key});
  final userName = "Mohammed";
  //list of blogs
  final _blogs = [
    [
      womanReading,
      'Read our articles',
      'Get insights on the latest news and tips from our experts.'
    ],
    [
      gynecologyConsultation,
      'Consult our doctors ',
      'Talk to our doctors to get better insight about your health.'
    ],
    [
      womanReading,
      'Read our articles',
      'Get insights on the latest news and tips from our experts.'
    ],
    [
      gynecologyConsultation,
      'Consult our doctors ',
      'Talk to our doctors to get better insight about your health.'
    ],
  ];

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    //for navigation bar
    setState(() {
      _currentIndex = index;
      if (_currentIndex != 0) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
  }

  void _showAlertAiBot(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;

    Future.delayed(
        Duration(
          seconds: (_currentIndex == 0) ? 20 : 0,
        ), () {
      setState(
        () {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 10),
              padding: const EdgeInsets.all(0),
              content: Container(
                  // margin: EdgeInsets.only(top: size.height * 0),
                  height: size.height * 0.1,
                  padding: const EdgeInsets.only(bottom: 12, right: 5, top: 5),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color.fromRGBO(110, 182, 255, 1)),
                            borderRadius:
                                BorderRadius.circular(size.width * 0.04)),
                        padding: EdgeInsets.all(size.height * 0.02),
                        child: const Text(
                            'Hello! Feel free to ask me anything, How can I assist you?',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTheme.floatingActionButtonAlertText),
                      ),
                      Positioned(
                        right: size.width * -0.01,
                        top: size.width * -0.01,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(110, 182, 255, 1),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: size.width * 0.02,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.width * -0.09,
                        left: size.width * 0.35,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: size.width * 0.15,
                          color: const Color.fromRGBO(110, 182, 255, 1),
                        ),
                      ),
                    ],
                  )),

              backgroundColor: Colors.transparent,
              behavior: SnackBarBehavior.floating,

              // width: size.width * 0.6,
              margin: EdgeInsets.only(
                  left: size.width * 0.45,
                  right: size.width * 0.05,
                  bottom: size.height * 0.02),
              elevation: 0,
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_currentIndex == 0) {
      _showAlertAiBot(context);
    }

    final List<Widget> _pages = [
      Column(
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: size.width * 0.06),
                width: size.width * 0.5,
                child: Text(
                  'Hello, $userName',
                  style: AppTheme.homePageUserNameTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: size.width * 0.08),
                width: size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(transalteIcon),
                    SvgPicture.asset(triangleExclamationIcon),
                    SvgPicture.asset(bellReminder),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.06, top: size.width * 0.06),
            width: double.infinity,
            child: const Text('Overview'),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: const Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OverviewCard(
                      icon: LineIcons.heart,
                      overviewResult: '120',
                      overviewUnit: 'BPM'),
                  OverviewCard(
                      icon: LineIcons.weight,
                      overviewResult: '21.6',
                      overviewUnit: 'BMI'),
                  OverviewCard(
                      icon: LineIcons.bed,
                      overviewResult: '6.5',
                      overviewUnit: 'hours'),
                ]),
          ),
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.06, top: size.height * 0.04),
            width: double.infinity,
            child: const Text(
              'Feeling unwell? Let us help you get better',
              textAlign: TextAlign.left,
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                left: size.width * 0.06,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  const Text(
                    'Tell us your symptoms',
                    style: AppTheme.helperTextForUserStyle,
                  ),
                  Icon(
                    LineIcons.arrowRight,
                    color: AppTheme.helperTextForUserStyle.color,
                  )
                ],
              )),
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.06, top: size.height * 0.03),
            width: double.infinity,
            child: const Text('Discover HealthPilot'),
          ),
          const DiscoverHealthpilot(),
          SizedBox(
            height: size.height * 0.02,
          ),
          AdWidget(),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.06, top: size.height * 0.03),
            width: double.infinity,
            child: const Text('Maintain a healthy lifestyle'),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            width: double.infinity,
            height: size.height * 0.35,
            child: ListView.builder(
              itemCount: _blogs.length,
              itemBuilder: (context, index) {
                return BlogRecomendationCard(
                    img: _blogs[index][0],
                    title: _blogs[index][1],
                    description: _blogs[index][2]);
              },
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
      const Center(
        child: Text('Health'),
      ),
      const Center(
        child: Text('Assesment'),
      ),
      const Center(
        child: Text('chat'),
      ),
      const Center(
        child: Text('profile'),
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        fixedColor: AppTheme.buttonStyleForFloatingActionBtn.backgroundColor,
        items: [
          BottomNavigationBarItem(
            // icon: Icon(LineIcons.home),
            icon: SvgPicture.asset(
              bottomNavBarHomeIcon,
              color: _currentIndex == 0
                  ? AppTheme.buttonStyleForFloatingActionBtn.backgroundColor
                  : null,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              bottomNavBarHealthIcon,
              color: _currentIndex == 1
                  ? AppTheme.buttonStyleForFloatingActionBtn.backgroundColor
                  : null,
            ),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              bottomNavBarAssesmentIcon,
              color: _currentIndex == 2
                  ? AppTheme.buttonStyleForFloatingActionBtn.backgroundColor
                  : null,
            ),
            label: 'Assesment',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              bottomNavBarChatIcon,
              color: _currentIndex == 3
                  ? AppTheme.buttonStyleForFloatingActionBtn.backgroundColor
                  : null,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              bottomNavBarProfileIcon,
              color: _currentIndex == 4
                  ? const Color.fromARGB(255, 69, 155, 241)
                  : null,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: _pages[_currentIndex],
      )),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () {},
              backgroundColor:
                  AppTheme.buttonStyleForFloatingActionBtn.backgroundColor,
              foregroundColor:
                  AppTheme.buttonStyleForFloatingActionBtn.foregroundColor,
              child: const Icon(LineIcons.robot),
            )
          : null,
    );
  }
}
