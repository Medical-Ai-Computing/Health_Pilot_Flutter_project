import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import 'package:healthpilot/theme/app_theme.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../data/contants.dart';

class SetupPersonalDoctor extends StatefulWidget {
  const SetupPersonalDoctor({super.key});

  @override
  State<SetupPersonalDoctor> createState() => _SetupPersonalDoctorState();
}

class _SetupPersonalDoctorState extends State<SetupPersonalDoctor> {
  int radioBtnStatus = 1;
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
            // Define the action when the back button is pressed
            // Navigator.pop(context);
          },
          style: AppTheme.buttonStyleForAppBarBackButto,
        ),
        title: const Text(
          'Setup Personal Doctor',
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
        child: Padding(
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
                        // labelText: 'First Name',
                        // labelStyle: const TextStyle(color: Colors.black),
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
                      'Personal Doctor Type',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                      ),
                    ),
                    DropDownTextField(
                      dropDownList: const [
                        DropDownValueModel(
                            name: 'Psychiatrists', value: 'Psychiatrists'),
                        DropDownValueModel(
                            name: 'Internists', value: 'Internists'),
                        DropDownValueModel(
                            name: 'Nephrologists', value: 'Nephrologists'),
                        DropDownValueModel(
                            name: 'Neurologists', value: 'Neurologists'),
                        DropDownValueModel(
                            name: 'Hematologists', value: 'Hematologists'),
                      ],
                      isEnabled: true,
                      textFieldDecoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: size.height * 0.015,
                            horizontal: size.width * 0.03),
                        border: const OutlineInputBorder(),
                        isDense: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: size.height * 0.015,
                            horizontal: size.width * 0.03),
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: size.height * 0.015,
                            horizontal: size.width * 0.03),
                        border: const OutlineInputBorder(),
                        isDense: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const Text(
                      'How frequently do you want your report to be sent',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.3,
                            height: size.height * 0.08,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomRadioBtn(
                                      value: 1,
                                      groupValue: radioBtnStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          radioBtnStatus = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    const Text(
                                      'Daily',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomRadioBtn(
                                      value: 2,
                                      groupValue: radioBtnStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          radioBtnStatus = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    const Text(
                                      'Weekly',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            // width: size.width * 0.3,
                            height: size.height * 0.08,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomRadioBtn(
                                      value: 3,
                                      groupValue: radioBtnStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          radioBtnStatus = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    const Text(
                                      'Bi-Week',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomRadioBtn(
                                      value: 4,
                                      groupValue: radioBtnStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          radioBtnStatus = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    const Text(
                                      'Monthly',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(110, 182, 255, 1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.25,
                          vertical: size.height * 0.02),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRadioBtn extends StatefulWidget {
  final int value;
  final int groupValue;
  final Function(int value) onChanged;
  CustomRadioBtn(
      {required this.value, required this.groupValue, required this.onChanged});

  @override
  State<CustomRadioBtn> createState() => _CustomRadioBtnState();
}

class _CustomRadioBtnState extends State<CustomRadioBtn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.004),
        height: size.height * 0.025,
        width: size.height * 0.025,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.height * 0.125),
          // color: Colors.blue,
          border:
              Border.all(color: const Color.fromARGB(23, 0, 0, 0), width: 2),
        ),
        child: widget.groupValue == widget.value
            ? Container(
                height: size.height * 0.015,
                width: size.height * 0.015,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * 0.075),
                  color: Colors.blue,
                  // border:
                  //     Border.all(color: const Color.fromARGB(23, 0, 0, 0), width: 2),
                ),
              )
            : null,
      ),
    );
  }
}
