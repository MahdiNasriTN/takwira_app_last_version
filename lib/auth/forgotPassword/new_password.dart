import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/auth/log_in.dart';
import 'package:takwira_app/views/navigation/navigation.dart';

class NewPassword extends StatefulWidget {
  final String? email;
  const NewPassword({super.key, this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  String? _password = '';
  late String _confirmPassword;
  String? errorMessage;

  void changePassword() async {
    final Uri url = Uri.parse('https://takwira.me/resetpassword/changepassword/${widget.email}');
    try {
      final http.Response response = await http.post(
        url,
        headers: {
          'flutter': 'true',
        },
        body: {
          'newpass': _password,
          'repnewpass': _confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var bodySuccess = responseBody['success'];
        print(bodySuccess);
        if (bodySuccess) {
          final str = "Password changed successfully for this email : ${widget.email}";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogIn(str : str),
            ),
          );
        } else {
          setState(() {
            errorMessage = responseBody['error'];
          });
        }
      } else {
        print('There is an error with the request');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double height(double height) {
      a = height / 932;
      return screenHeight * a;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/4aw.png',
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.only(top: height(350)),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(0, 0, 0, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Image.asset(
            'assets/images/smoke.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.15),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width(20), 0, width(20), width(20)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: height(10)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color(0xffF1EED0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height(70)),
                    Padding(
                      padding: EdgeInsets.only(left: width(35)),
                      child: Image.asset('assets/images/newPassword.png'),
                    ),
                    SizedBox(height: height(30)),
                    Text(
                      'Create new Password',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height(15)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Choose a strong and memorable password this time. It\'s important to ensure that your new password is secure and easy for you to remember.',
                        style: TextStyle(color: Color(0xffF1EED0)),
                      ),
                    ),
                    SizedBox(height: height(60)),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        } else if (value.length < 8 || value.length > 100) {
                          return 'Password must be 8 to 100 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your Password';
                        } else if (value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: true,
                      onSaved: (value) {
                        _confirmPassword = value!;
                      },
                    ),
                    if (errorMessage != null) // Error message display
                      Padding(
                        padding: EdgeInsets.only(top: height(10)),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: width(14),
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFF1EED0),
                        backgroundColor: const Color(0xFF599068), // button's shape
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          changePassword();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(width(13)),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
