import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RatePlayer extends StatefulWidget {
  const RatePlayer({super.key});

  @override
  State<RatePlayer> createState() => _RatePlayerState();
}

class _RatePlayerState extends State<RatePlayer> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return SizedBox(
      width: width(300),
      child: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 10,
                divisions: 100,
                activeColor: const Color(0xff599068),
                inactiveColor: const Color(0xffF1EED0).withOpacity(0.3),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue =
                        double.parse(value.toStringAsFixed(1));
                  });
                },
              ),
            ),
            Image.asset(
              'assets/images/10.png',
              width: width(18),
              height: width(18),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width(79)),
          child: Column(
            children: [
              SizedBox(height: width(35)),
              Text(
                '$_currentSliderValue',
                style: TextStyle(
                    color: const Color(0xFF599068),
                    fontSize: width(20),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: width(10)),
              SizedBox(
                width: width(142),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width(9)),
                    ),
                    foregroundColor: const Color(0xFFF1EED0),
                    backgroundColor: const Color(0xFF599068),
                    padding: EdgeInsets.symmetric(
                        horizontal: width(15), vertical: width(13)),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Rate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
