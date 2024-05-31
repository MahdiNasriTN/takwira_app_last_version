import 'package:flutter/material.dart';

class NumberSelector extends StatelessWidget {
  final int selectedNumber;
  final int itemCount;
  final ValueChanged<int> onNumberSelected;

  const NumberSelector({
    required this.selectedNumber,
    required this.itemCount,
    required this.onNumberSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return Row(
      children: [
        Text(
          '$selectedNumber',
          style: TextStyle(
            color: const Color(0xFFF1EED0),
            fontSize: width(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () => _showNumberPicker(context),
          icon: Image.asset(
            'assets/images/playerNo.png',
            width: width(15),
            height: width(15),
          ),
        ),
      ],
    );
  }

  void _showNumberPicker(BuildContext context) {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'You\'re one of those players\nDon\'t forget to count yourself..!',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: const TextStyle(
            color: Color(0xffC3C1A3),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: const Color(0xFF599068).withOpacity(0.4),
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              width: 10,
              height: 300,
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final number = index + 2;
                  return ListTile(
                    title: Center(
                      child: Text(
                        '$number players',
                        style: const TextStyle(
                          color: Color(0xffF1EED0), // Set the text color
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(number);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        onNumberSelected(value);
      }
    });
  }
}
