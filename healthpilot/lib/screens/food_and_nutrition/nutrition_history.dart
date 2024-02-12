import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class History extends StatelessWidget {
  History({Key? key});
  final List<Map<String, String>> schedules = [
    {
      'schedule': 'Breakfast',
      'energy': '350kcal',
    },
    {
      'schedule': 'Lunch',
      'energy': '350kcal',
    },
    {
      'schedule': 'Dinner',
      'energy': '350kcal',
    }
  ];

  final String date = '12:00 PM, February 11, 2024';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
  preferredSize: Size(double.infinity, size.height * 0.2),
  child: Padding(
    padding: const EdgeInsets.only(
      left: 20,
      right: 20,
      top: 50,
      bottom: 10,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: size.width * 0.1,
              height: size.width * 0.1,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(110, 182, 255, 0.25),
                borderRadius: BorderRadius.circular(size.width * 0.05),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromRGBO(110, 182, 255, 1),
                iconSize: size.width * 0.055,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.08,
                0,
                0,
                0,
              ),
              child: SizedBox(
                width: size.width * 0.4,
                child: Text(
                  "Food and Nutrition Tracking History",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w600,
                    fontFamily: "PlusJakartaSans",
                  ),
                ),
              ),
            ),
          ],
        ),
        SvgPicture.asset('assets/images/Vector.svg', fit: BoxFit.cover),
      ],
    ),
  ),
),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:13.0,top:25,bottom:20),
            child: Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromARGB(255, 123, 186, 238),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.3,
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                return NutritionTrackingHistory(
                  schedule: schedules[index]['schedule']!,
                  energy: schedules[index]['energy']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionTrackingHistory extends StatelessWidget {
  final String schedule;
  final String energy;

  const NutritionTrackingHistory({
    Key? key,
    required this.schedule,
    required this.energy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width * 0.003,
                height: size.height * 0.08,
                color: const Color.fromRGBO(110, 182, 255, 0.25),
              ),
              Container(
                width: size.width * 0.03,
                height: size.width * 0.03,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.015),
                  color: const Color.fromRGBO(110, 182, 255, 0.25),
                ),
              ),
              Container(
                width: size.width * 0.03,
                height: size.width * 0.03,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.015),
                  color: const Color.fromRGBO(110, 182, 255, 0.25),
                ),
              ),
            ],
          ),
          SizedBox(width: size.width * 0.02),
          SizedBox(
            width: size.width * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.45,
                  child: Text(
                    schedule,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  energy,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "PlusJakartaSans",
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(110, 182, 255, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
