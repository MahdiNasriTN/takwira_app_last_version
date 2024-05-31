import 'package:flutter/material.dart';

class Code extends StatefulWidget {
  final Function(String) onCodeChanged;
  const Code({super.key, required this.onCodeChanged});

  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {
  late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;
  late FocusNode _thirdFocusNode;
  late FocusNode _fourthFocusNode;
  late TextEditingController _firstController;
  late TextEditingController _secondController;
  late TextEditingController _thirdController;
  late TextEditingController _fourthController;

  @override
  void initState() {
    super.initState();
    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
    _fourthFocusNode = FocusNode();
    _firstController = TextEditingController();
    _secondController = TextEditingController();
    _thirdController = TextEditingController();
    _fourthController = TextEditingController();
    _addListeners();
  }

  @override
  void dispose() {
    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    _fourthFocusNode.dispose();
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    super.dispose();
  }

  void _addListeners() {
    _firstController.addListener(_updateCode);
    _secondController.addListener(_updateCode);
    _thirdController.addListener(_updateCode);
    _fourthController.addListener(_updateCode);
  }

  void _updateCode() {
    String code = _firstController.text +
        _secondController.text +
        _thirdController.text +
        _fourthController.text;
    widget.onCodeChanged(code);
  }

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextField(_firstFocusNode, _firstController, width),
        _buildTextField(_secondFocusNode, _secondController, width),
        _buildTextField(_thirdFocusNode, _thirdController, width),
        _buildTextField(_fourthFocusNode, _fourthController, width),
      ],
    );
  }

  Widget _buildTextField(FocusNode focusNode, TextEditingController controller,
      double Function(double) width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width(20)),
      child: Container(
        width: width(80),
        height: width(80),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff599068),
            width: width(2),
          ),
          borderRadius: BorderRadius.circular(width(20)),
        ),
        child: Container(
          color: Colors.transparent,
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            style: TextStyle(
                color: Color(0xff599068),
                fontSize: width(30),
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: '|',
              hintStyle: TextStyle(
                color: const Color(0xff599068),
                fontSize: width(24),
                fontWeight: FontWeight.w100,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14.0),
              border: InputBorder.none,
              counterText: '',
            ),
            textAlign: TextAlign.center,
            maxLength: 1,
          ),
        ),
      ),
    );
  }
}
