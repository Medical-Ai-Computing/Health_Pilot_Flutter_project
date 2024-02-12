import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodAndNutritionTracking extends StatelessWidget {
  const FoodAndNutritionTracking({Key? key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = constraints.biggest;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, size.height * 0.1),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
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
                          size.width * 0.05,
                          0,
                          0,
                          0,
                        ),
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: Text(
                            "Food and Nutirition tracking",
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
          body: Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader('How frequently do you want your report to be sent', 16),
                const SizedBox(height: 25),
                _buildFrequencyButtons(),
                const SizedBox(height: 36),
                _buildPushNotificationSwitch(),
                const SizedBox(height: 18),
                _buildNotificationText(),
                const SizedBox(height: 26),
                _buildHeader('Select any diets you follow', 18),
                const SizedBox(height: 18),
                _buildDietButtons(),
                const SizedBox(height: 140),
                _buildFinishButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String text, double fontSize) =>
      Text(text, style: TextStyle(fontSize: fontSize));

  Widget _buildCircleButton(String text) => CircleButton(text: text);

  Widget _buildPushNotificationSwitch() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Enable Push Notifications', style: TextStyle(fontSize: 18)),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Switch(
              value: true,
              onChanged: (bool value) {},
              activeTrackColor: Colors.grey[400],
              activeColor: Colors.blue,
            ),
          ),
        ],
      );

  Widget _buildNotificationText() => const Text(
        'This will send you notifications to eat regularly during eating times and have a balanced diet.',
        style: TextStyle(fontSize: 14),
      );

  _buildFinishButton() => Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement your finish logic here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Finish',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );

  Column _buildFrequencyButtons() {
    return Column(
      children: [
        Row(
          children: [
            _buildCircleButton('Daily'),
            const SizedBox(width: 169),
            _buildCircleButton('Bi-weekly'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildCircleButton('Weekly'),
            const SizedBox(width: 155),
            _buildCircleButton('Monthly'),
          ],
        ),
      ],
    );
  }

  Widget _buildDiet({required List<String> labels}) => Row(
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: SizedBox(
              height: 40.0,
              child: Container(
                decoration: BoxDecoration(
                  color: (index < labels.length - 1 && labels[0] == 'Vegetarian' || labels[0] == 'Vegan')
                      ? Colors.blue.withOpacity(0.4)
                      : null,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: (index < labels.length - 1 && labels[0] == 'Vegetarian' || labels[0] == 'Vegan')
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildDietButtons() => Column(
        children: [
          _buildDiet(
            labels: ['Vegetarian', 'Vegan', 'Vegetarian'],
          ),
          const SizedBox(height: 10),
          _buildDiet(
            labels: ['Atkins', 'Vegan', 'Vegetarian'],
          ),
        ],
      );
}

class CircleButton extends StatefulWidget {
  final String text;

  const CircleButton({required this.text, Key? key}) : super(key: key);

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => isSelected = !isSelected),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ],
      );
}
