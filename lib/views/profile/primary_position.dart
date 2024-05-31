import 'package:flutter/material.dart';

class PrimaryPosition extends StatefulWidget {
  final String selectedPosition;
  final List<String> availablePositions;
  final ValueChanged<String> onPositionSelected;

  const PrimaryPosition({
    required this.selectedPosition,
    required this.availablePositions,
    required this.onPositionSelected,
    super.key,
  });

  @override
  _PrimaryPositionState createState() => _PrimaryPositionState();
}

class _PrimaryPositionState extends State<PrimaryPosition> {
  String? selectedPosition;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    String positionText = _getPositionText();
    return IconButton(
      onPressed: () => _showPositionPicker(context),
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            positionText,
            style: TextStyle(
              color: const Color(0xffF1EED0),
              fontSize: width(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: width(10)),
          Image.asset(
            'assets/images/position.png',
            width: width(18),
            height: width(18),
          ),
        ],
      ),
    );
  }

  String _getPositionText() {
    return widget.selectedPosition?.isEmpty ?? true
        ? 'none'
        : widget.selectedPosition!;
  }

  void _showPositionPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              width: 300,
              height: 426.52,
              child: Stack(
                children: [
                  // Background image
                  Image.asset(
                    'assets/images/positionField.png',
                    fit: BoxFit.cover,
                  ),
                  // Stack of position images and texts
                  Positioned(
                    left: 117.5,
                    bottom: 5,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'GK', widget.selectedPosition.contains('GK'), () {
                        _updateSelectedPosition('GK');
                      }),
                    ),
                  ),
                  Positioned(
                    left: 117.5,
                    bottom: 71,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'CB', widget.selectedPosition.contains('CB'), () {
                        _updateSelectedPosition('CB');
                      }),
                    ),
                  ),
                  Positioned(
                    left: 117.5,
                    bottom: 137,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'CDM', widget.selectedPosition.contains('CDM'), () {
                        _updateSelectedPosition('CDM');
                      }),
                    ),
                  ),
                  Positioned(
                    left: 117.5,
                    bottom: 204,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'CM', widget.selectedPosition.contains('CM'), () {
                        _updateSelectedPosition('CM');
                      }),
                    ),
                  ),
                  Positioned(
                    left: 117.5,
                    top: 80,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'CAM', widget.selectedPosition.contains('CAM'), () {
                        _updateSelectedPosition('CAM');
                      }),
                    ),
                  ),
                  Positioned(
                    right: 117.5,
                    top: 5,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'ST', widget.selectedPosition.contains('ST'), () {
                        _updateSelectedPosition('ST');
                      }),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 85,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'RB', widget.selectedPosition.contains('RB'), () {
                        _updateSelectedPosition('RB');
                      }),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 85,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'LB', widget.selectedPosition.contains('LB'), () {
                        _updateSelectedPosition('LB');
                      }),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 40,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'RW', widget.selectedPosition.contains('RW'), () {
                        _updateSelectedPosition('RW');
                      }),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 40,
                    child: IconButton(
                      onPressed: () {},
                      icon: _buildPositionStack(
                          'LW', widget.selectedPosition.contains('LW'), () {
                        _updateSelectedPosition('LW');
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositionStack(
    String position,
    bool isSelected,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/profileIcon.png',
            width: 50,
            height: 50,
          ),
          Image.asset(
            'assets/images/profileIcon.png',
            width: 50,
            height: 50,
            color: isSelected
                ? const Color(0xff599068).withOpacity(0.2)
                : const Color(0xff923E3E).withOpacity(0.2),
          ),
          Text(
            position,
            style: const TextStyle(
              color: Color(0xffF1EED0),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            position,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xff599068)
                  : const Color(0xff923E3E),
              fontSize: 15,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }

  void _updateSelectedPosition(String position) {
    if (mounted) {
      // Check if the widget is mounted
      setState(() {
        selectedPosition = position; // Update the selected position
      });
      widget.onPositionSelected(
          position); // Call the callback with the selected position
    }
  }
}
