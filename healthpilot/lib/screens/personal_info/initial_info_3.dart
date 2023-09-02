import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthpilot/data/contants.dart';
import 'package:healthpilot/screens/personal_info/initial_info_4.dart';

import '../../theme/app_theme.dart';

class InitialInfoThird extends StatefulWidget {
  const InitialInfoThird({Key? key}) : super(key: key);

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
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(110, 182, 255, 1)),
          onPressed: () {
            // Define the action when the back button is pressed
            // Navigator.pop(context);
          },
          style: AppTheme.buttonStyleForAppBarBackButto,
        ),
        title: const Text(
          "One Last Step",
          style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.black),
          maxLines: 2,
        ),
        actions: [
          SvgPicture.asset(transalteIcon),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 18.0, left: 18),
                child: Text(
                  "Do you have any allergies?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      // Use OutlineInputBorder for visible borders
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(41, 41, 41, 0.5)),
                      borderRadius: BorderRadius.circular(
                          13.0), // Adjust the radius as needed
                    ),
                    hintText: 'Search Allergies',
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromRGBO(41, 41, 41, 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              searchController.text.isNotEmpty || selectedAllergies.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      height: size.height * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (searchController.text.isNotEmpty)
                            const Text(
                              'Available Allergies:',
                              style: TextStyle(
                                fontFamily: ' PlusJakartaSans',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (searchController.text.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredAllergies.length,
                                itemBuilder: (context, index) {
                                  final allergy = filteredAllergies[index];
                                  return ListTile(
                                    title: Text(allergy),
                                    trailing:
                                        selectedAllergies.contains(allergy)
                                            ? const Icon(
                                                Icons.add_circle,
                                                color: Color.fromRGBO(
                                                    110, 182, 255, 1),
                                              )
                                            : const Icon(
                                                Icons.add_circle_outline,
                                                color: Color.fromRGBO(
                                                    110, 182, 255, 1),
                                              ),
                                    onTap: () {
                                      setState(() {
                                        if (selectedAllergies
                                            .contains(allergy)) {
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
                          // const SizedBox(height: 10.0),
                          if (selectedAllergies.isNotEmpty)
                            const Text(
                              'Selected Allergies:',
                              style: TextStyle(
                                fontFamily: ' PlusJakartaSans',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: selectedAllergies.map((allergy) {
                              return ListTile(
                                title: Text(allergy),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.highlight_remove_rounded,
                                    color: Colors.red,
                                  ),
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
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'No allergies added',
                            style: TextStyle(
                              fontFamily: ' PlusJakartaSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          SizedBox(
                            width: size.width * 0.6,
                            child: const Text(
                              'Search the allergies you have and press the + button to add them',
                              style: TextStyle(
                                fontFamily: ' PlusJakartaSans',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    selectedAllergies.isEmpty
                        ? null
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InitialInfoFinal()), // Navigate to the DestinationPage
                          );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAllergies.isEmpty
                          ? const Color.fromARGB(255, 200, 224, 249)
                          : const Color.fromRGBO(110, 182, 255, 1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.25,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Finish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
