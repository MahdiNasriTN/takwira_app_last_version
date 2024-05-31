import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/auth/forgotPassword/email_verif_pass.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    late String _email;

    void resetPassword() async {
      final Uri url = Uri.parse('https://takwira.me/resetpassword');
      print(_email);
      try {
        final http.Response response = await http.post(
          url,
          headers: {
            'flutter': 'true',
          },
          body: {'resetemail': _email},
        );

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var bodySuccess = responseBody['success'];
          print(bodySuccess);
          if (bodySuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmailVerifPass(email: _email),
              ),
            );
          } else {}
        } else {}
      } catch (e) {
        print(e);
      }
    }

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
                    child: Image.asset('assets/images/forgotPassword.png'),
                  ),
                  SizedBox(height: height(30)),
                  Text(
                    'Forgot your Password?',
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
                      'We\'ll be sending you an email to confirm that you\'re the rightful user. This helps us ensure the security of your account and provide you with the best experience possible. \nThank you for your cooperation in this matter.',
                      style: TextStyle(color: Color(0xffF1EED0)),
                    ),
                  ),
                  SizedBox(height: height(70)),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: width(60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width(20)),
                        border: Border.all(color: Color(0xFFF1EED0)),
                      ),
                      child: Container(
                        width: 2000,
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              width(20), width(14), 0, width(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  style:
                                      const TextStyle(color: Color(0xFFF1EED0)),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(
                                      color: const Color(0xFFBEBCA5),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _email = value!;
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    resetPassword();
                                  }
                                },
                                child: Image.asset(
                                  'assets/images/send.png',
                                  width: width(80),
                                  height: width(80),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
