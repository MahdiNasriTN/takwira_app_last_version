import 'package:flutter/material.dart';

class AgeGroup extends StatefulWidget {
  const AgeGroup({super.key});

  @override
  State<AgeGroup> createState() => _AgeGroupState();
}

class _AgeGroupState extends State<AgeGroup> {
  RangeValues _currentRangeValues = const RangeValues(8, 80);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentRangeValues.start.round().toString(),
              style: TextStyle(
                color: const Color(0xFFBFBCA0),
                fontSize: width(12),
              ),
            ),
            Text(
              '  -  ',
              style: TextStyle(
                color: const Color(0xFFBFBCA0),
                fontSize: width(12),
              ),
            ),
            Text(
              _currentRangeValues.end.round().toString(),
              style: TextStyle(
                color: const Color(0xFFBFBCA0),
                fontSize: width(12),
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _currentRangeValues,
          min: 8,
          max: 80,
          activeColor: const Color(0xff599068),
          inactiveColor: const Color(0xffF1EED0).withOpacity(0.3),
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
      ],
    );
  }
}
