import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String suffixIconImage;
  final String title;
  final IconData leadingIcon;
  const CustomAppBar(
      {super.key,
      required this.onPressed,
      required this.suffixIconImage,
      required this.title,
      required this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          maxRadius: 10,
          backgroundColor: const Color.fromRGBO(110, 182, 255, 0.25),
          child: InkWell(
            child: Icon(
              leadingIcon,
              color: const Color.fromRGBO(110, 182, 255, 1),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
      title: Text(title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color.fromRGBO(42, 42, 42, 1),
          )),
      actions: [
        GestureDetector(
          onTap: onPressed,
          child: Image(
            image: AssetImage(suffixIconImage),
          ),
        ),
      ],
    );
  }
}
