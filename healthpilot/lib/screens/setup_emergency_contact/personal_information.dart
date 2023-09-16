import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthpilot/screens/setup_emergency_contact/setup_emergency_contact.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:line_icons/line_icons.dart';

import '../../data/contants.dart';
import '../../theme/app_theme.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  int emergencyContactCount = 0;
  int personalContactCount = 0;
  void addEmergencyContact() {
    if (emergencyContactCount < 3) {
      setState(() {
        emergencyContactCount++;
      });
    }
  }

  void addDoctor() {
    if (personalContactCount < 3) {
      setState(() {
        personalContactCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: AppTheme.buttonStyleForAppBarBackButto,
        ),
        title: const Text(
          'Personal Information',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
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
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.1,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.08),
                          child: Image.asset(
                            height: size.width * 0.25,
                            personPicForprofile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: size.width * 0.16, left: size.width * 0.13),
                        child: Container(
                            height: size.width * 0.04,
                            width: size.width * 0.04,
                            padding: EdgeInsets.only(left: size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                size.width * 0.02,
                              ),
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Icon(
                              LineIcons.edit,
                              size: size.width * 0.03,
                              color: const Color.fromARGB(255, 73, 70, 70),
                            )),
                      ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  const Text(
                    'Upload your profile photo',
                    style: AppTheme.helperTextForUserStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08, vertical: size.width * 0.08),
              child: Form(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'First Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                          ),
                        ),
                        TextFormField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.03),
                            border: const OutlineInputBorder(),
                            isDense: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 214, 210, 210)),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                          ),
                        ),
                        TextFormField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            // labelText: 'Last Name',
                            // labelStyle: const TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.03),
                            // label: Text('First Name'),
                            border: const OutlineInputBorder(),
                            isDense: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                          ),
                        ),
                        TextFormField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            // labelText: 'Email',
                            // labelStyle: const TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.03),
                            // label: Text('First Name'),
                            border: const OutlineInputBorder(),
                            isDense: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                          ),
                        ),
                        IntlPhoneField(
                          disableLengthCheck: true,
                          dropdownIconPosition: IconPosition.trailing,
                          decoration: InputDecoration(
                            // labelText: 'Phone Number',
                            // labelStyle: const TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.03),
                            // label: Text('First Name'),
                            border: const OutlineInputBorder(),
                            isDense: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Emergency Contacts',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () {
                              // addEmergencyContact();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const SetupEmergencyContact(),
                              ));
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: emergencyContactCount <= 0
                          ? size.height * 0.08
                          : size.height * 0.08 * emergencyContactCount,
                      child: emergencyContactCount <= 0
                          ? const Center(
                              child: Text(
                                'No emergency contact found!',
                                style: TextStyle(
                                    color: Color.fromRGBO(110, 182, 255, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          : ListView.builder(
                              itemCount: emergencyContactCount,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: size.width * 0.003,
                                          height: size.height * 0.08,
                                          color: const Color.fromRGBO(
                                              110, 182, 255, 1),
                                        ),
                                        Container(
                                          width: size.width * 0.03,
                                          height: size.width * 0.03,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.015),
                                            color: const Color.fromRGBO(
                                                110, 182, 255, 1),
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.03,
                                          height: size.width * 0.03,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.015),
                                            color: const Color.fromRGBO(
                                                110, 182, 255, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.02),
                                      width: size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Bobby Firminio'),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        110, 182, 255, 1),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            child: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Personal Contacts',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () {
                              // addDoctor();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SetupEmergencyContact(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: personalContactCount <= 0
                          ? size.height * 0.08
                          : size.height * 0.08 * personalContactCount,
                      child: personalContactCount <= 0
                          ? const Center(
                              child: Text(
                                'No personal contact found!',
                                style: TextStyle(
                                    color: Color.fromRGBO(110, 182, 255, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          : ListView.builder(
                              itemCount: personalContactCount,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: size.width * 0.003,
                                          height: size.height * 0.08,
                                          color: const Color.fromRGBO(
                                              110, 182, 255, 1),
                                        ),
                                        Container(
                                          width: size.width * 0.03,
                                          height: size.width * 0.03,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.015),
                                            color: const Color.fromRGBO(
                                                110, 182, 255, 1),
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.03,
                                          height: size.width * 0.03,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.015),
                                            color: const Color.fromRGBO(
                                                110, 182, 255, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.02),
                                      width: size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Bobby Firminio'),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        110, 182, 255, 1),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            child: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.02),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(183, 216, 249, 0.786),
                                Color.fromRGBO(255, 255, 255, 1)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )),
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Set up food and nutrition tracking',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            const Text(
                              'Start setting up your food and nutrition tracking to keep hold of your data on what u eat and drink.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(110, 182, 255, 1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Start Setup',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    fontFamily: 'Plus Jakarta Sans',
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.07,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(110, 182, 255, 1),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.25,
                              vertical: size.height * 0.02),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('Finish'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
