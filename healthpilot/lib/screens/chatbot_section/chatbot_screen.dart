import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        height: 37,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Message', border: InputBorder.none),
              ),
            ),
            Icon(
              Icons.send,
              color: Color.fromARGB(
                255,
                110,
                182,
                255,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(63, 110, 182, 255),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 9, left: 20),
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 110, 182, 255),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 110, 182, 255),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            LineIcons.robot,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'HealthBot',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 110, 182, 255),
                            size: 11,
                          ),
                        ],
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(42, 42, 42, 0.50)),
                      )
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.more_vert),
                ],
              ),
              Expanded(
                child: ListView(
                  reverse: true,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(110, 182, 255, 0.30),
                                Color.fromRGBO(110, 182, 255, 0.26),
                                Color.fromRGBO(110, 182, 255, 0.08),
                              ],
                              stops: [
                                0.17,
                                0.75,
                                1
                              ]
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('What causes high BP', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600,),),
                                Text('for people aged 25-30 eating low carbs usually', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w400,),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12,),
                        Expanded(
                          child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                Text('Tell me the sypmtoms', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600,),),
                                Text('of malaria in children aged from 2-6', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w400,),),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(110, 182, 255, 0.30),
                            Color.fromRGBO(110, 182, 255, 0.26),
                            Color.fromRGBO(110, 182, 255, 0.08),
                          ],
                          stops: [
                            0.17,
                            0.75,
                            1
                          ]
                                              )),
                                            ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: Bubble(
                        radius: Radius.circular(5),
                        nip: BubbleNip.leftBottom,
                        margin: BubbleEdges.all(0),
                        padding: BubbleEdges.all(0),
                        showNip: true,
                        color: Color.fromRGBO(110, 182, 255, 0.30),
                        shadowColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Container(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Text('Hey there 👋, am always here to answer your questions. Write your personal questions or choose from the prompts', style: GoogleFonts.plusJakartaSans(color: Colors.transparent,fontSize: 12, fontWeight: FontWeight.w400),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('8:14',style: GoogleFonts.plusJakartaSans(fontSize: 8, fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(110, 182, 255, 0.30),
                                Color.fromRGBO(110, 182, 255, 0.26),
                                Color.fromRGBO(110, 182, 255, 0.08),
                              ],
                              stops: [
                                0.17,
                                0.75,
                                1
                              ]
                            )),
                              child: Column(
                                children: [
                                  Text('Hey there 👋, am always here to answer your questions. Write your personal questions or choose from the prompts', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('8:14 am', style: GoogleFonts.plusJakartaSans(fontSize: 8, fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
