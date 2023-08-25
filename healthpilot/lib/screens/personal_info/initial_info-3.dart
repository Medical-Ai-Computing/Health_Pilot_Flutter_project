import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/home_page_screen.dart/home_page_screen.dart';
import 'package:healthpilot/screens/personal_info/initial_info-4.dart';

import '../../theme/app_theme.dart';

class InitialInfoThird extends StatefulWidget {
  InitialInfoThird({Key? key}) : super(key: key);

  @override
  State<InitialInfoThird> createState() => _InitialInfoThird();
}

class _InitialInfoThird extends State<InitialInfoThird> {

  List<String> allergies = [];
  List<String> selectedAllergies = [];
  List<String> availableAllergies = [
    "Peanuts",
    "Milk",
    "Eggs",
    "Shellfish",
    "Tree Nuts",
    "Soy",
    "Wheat",
  ];
  TextEditingController searchController = TextEditingController();
  List<String> get filteredAllergies {
    final searchText = searchController.text.toLowerCase();
    return availableAllergies
        .where((allergy) => allergy.toLowerCase().contains(searchText))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(110, 182, 255, 1)),
            onPressed: () {
              // Define the action when the back button is pressed
              // Navigator.pop(context);
            },
            style: AppTheme.buttonStyleForAppBarBackButto,
          ),
          title: const Text(
            "One Last Step",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
            maxLines: 2,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InitialInfoFinal()), // Navigate to the DestinationPage
                    );
                  },
                  icon: Icon(Icons.done,color: Color.fromRGBO(110, 182, 255, 1),)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 18.0, left: 18),
                child: Text(
                  "Do you have any allergies?",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.black),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder( // Use OutlineInputBorder for visible borders
                      borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                    ),
                    hintText: 'Search Allergies',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              SizedBox(height: 16.0),
              if (searchController.text.isNotEmpty)
                Text(
                  'Available Allergies:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              if (searchController.text.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAllergies.length,
                    itemBuilder: (context, index) {
                      final allergy = filteredAllergies[index];
                      return ListTile(
                        title: Text(allergy),
                        trailing: selectedAllergies.contains(allergy)
                            ? Icon(Icons.add_circle,color: Color.fromRGBO(110, 182, 255, 1),)
                            : Icon(Icons.add_circle_outline,color: Color.fromRGBO(110, 182, 255, 1),),
                        onTap: () {
                          setState(() {
                            if (selectedAllergies.contains(allergy)) {
                              selectedAllergies.remove(allergy);
                            } else {
                              selectedAllergies.add(allergy);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 10.0),
              Text(
                'Selected Allergies:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedAllergies.map((allergy) {
                  return ListTile(
                    title: Text(allergy),
                    trailing: IconButton(
                      icon: Icon(Icons.highlight_remove_rounded, color: Colors.red, ),
                      onPressed: () {
                        setState(() {
                          selectedAllergies.remove(allergy);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),


            ],
          ),
        ),
    );
  }
}


