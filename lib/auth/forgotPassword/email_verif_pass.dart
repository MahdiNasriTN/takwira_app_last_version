import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:takwira_app/auth/emailVerif/code.dart';
import 'package:takwira_app/auth/emailVerif/count_down_timer.dart';
import 'package:takwira_app/auth/forgotPassword/new_password.dart';

class EmailVerifPass extends StatefulWidget {
  final dynamic? email;
  const EmailVerifPass({super.key, this.email});

  @override
  _EmailVerifPassState createState() => _EmailVerifPassState();
}

class _EmailVerifPassState extends State<EmailVerifPass> {
  String _verificationCode = '';

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    void verifyResetCode() async {
      final Uri url = Uri.parse('https://takwira.me/resetpassword/${widget.email}');
      try {
        final http.Response response = await http.post(
          url,
          headers: {
            'flutter': 'true',
          },
          body: {
            'codeverif': _verificationCode,
          },
        );

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var bodySuccess = responseBody['success'];
          print(bodySuccess);
          if (bodySuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPassword(email : widget.email)),
            );
          } else {
            // Handle error
          }
        } else {
          // Handle error
        }
      } catch (e) {
        print(e);
      }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width(40), height(130), width(40), 0),
                    child: Text(
                      'Enter your Verification Code',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(32),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: width(55)),
                  Code(
                    onCodeChanged: (code) {
                      setState(() {
                        _verificationCode = code;
                      });
                    },
                  ),
                  SizedBox(height: width(57)),
                  CountdownTimer(),
                  SizedBox(height: width(26)),
                  Text(
                    'We send Verification code to your',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width(16),
                        color: Color(0xffF1EED0)),
                  ),
                  Row(
                    children: [
                      Text(
                        'email ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width(16),
                            color: Color(0xffF1EED0)),
                      ),
                      Text(
                        '${widget.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width(16),
                            color: Color(0xff599068)),
                      ),
                    ],
                  ),
                  Text(
                    'Check your inbox.',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width(16),
                        color: Color(0xffF1EED0)),
                  ),
                  SizedBox(height: width(50)),
                  Row(
                    children: [
                      Text(
                        'I didn\'t received the code?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: width(16),
                            color: Color(0xff599068)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sent again',
                          style: TextStyle(
                              color: Color(0xFF599068),
                              fontSize: width(16),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFFF1EED0),
                          backgroundColor: Color(0xFF599068),
                        ),
                        onPressed: () {
                          verifyResetCode();
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              width(33), width(13), width(33), width(13)),
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
