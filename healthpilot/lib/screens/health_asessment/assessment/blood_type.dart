import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BloodType extends StatelessWidget {
  const BloodType({Key? key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leading: Padding(
    padding: const EdgeInsets.only(top:10,left:15),
    child: Container(
      width: size.width * 0.1,
      height: size.width * 0.1,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(110, 182, 255, 0.25),
        borderRadius: BorderRadius.circular(size.width * 0.07),
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
  ),
  title: Padding(
    padding: const EdgeInsets.only(top:20,right:90,bottom:15),
    child: Center(
      child: Text(
        "Health Assessment",
        style: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w600,
          fontFamily: "PlusJakartaSans",
        ),
      ),
    ),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(top:20,right:18),
      child: SvgPicture.asset(
        'assets/images/Vector.svg',
        fit: BoxFit.cover,
        width: size.width * 0.08,
        height: size.width * 0.08,
      ),
    ),
  ],
),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "What is their blood type?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color.fromRGBO(110, 182, 255, 1),
                    ),
                  ),
                  child: const Text("type A"),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color.fromRGBO(110, 182, 255, 1),
                    ),
                  ),
                  child: const Text("type A"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color.fromRGBO(110, 182, 255, 1),
                    ),
                  ),
                  child: const Text("type AB"),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color.fromRGBO(110, 182, 255, 1),
                    ),
                  ),
                  child: const Text("type O"),
                ),
              ),
                const SizedBox(height: 100),
              SizedBox(
                width: size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor:  const Color.fromRGBO(110, 182, 255, 1),
                    side: const BorderSide(
                      color: Color.fromRGBO(110, 182, 255, 1),
                    ),
                  ),
                  child: const Text("Skip"),
                ),
              ),
              const SizedBox(height: 100),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 16),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(110, 182, 255, 1),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text("Don't understand? Here is a discrption", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 12), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 16),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(110, 182, 255, 1),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text("Why am i being asked", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}