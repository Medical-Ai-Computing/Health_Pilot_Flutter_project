import 'package:flutter/material.dart';

class CustomAppBarTitle extends StatefulWidget {
  final String title;
  final IconData leadingIcon;
  final String suffixIconImage;
  final Function() onPressed;
  const CustomAppBarTitle(
      {super.key,
      required this.title,
      required this.leadingIcon,
      required this.suffixIconImage,
      required this.onPressed});

  @override
  State<CustomAppBarTitle> createState() => _CustomAppBarTitleState();
}

class _CustomAppBarTitleState extends State<CustomAppBarTitle> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size.width * 0.097,
          height: size.height * 0.047,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(110, 182, 255, 0.25),
          ),
          child: InkWell(
            child: Icon(
              widget.leadingIcon,
              color: const Color.fromRGBO(110, 182, 255, 1),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.031,
        ),
        Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color.fromRGBO(42, 42, 42, 1),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: widget.onPressed,
          child: Image(
            image: AssetImage(widget.suffixIconImage),
          ),
        ),
      ],
    );
  }
}
