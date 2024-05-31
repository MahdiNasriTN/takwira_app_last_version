import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:takwira_app/auth/emailVerif/email_verif.dart';
import 'package:takwira_app/auth/log_in.dart';
import 'package:takwira_app/views/navigation/navigation.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _userName;
  late String _phoneNumber;
  late String _email;
  String? _password = '';
  late String _confirmPassword;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void signUp(BuildContext context) async {
      var url = Uri.parse('https://takwira.me/register');
      var response = await http.post(
        url,
        headers: {
          'flutter': 'true',
        },
        body: {
          'fName': firstNameController.text,
          'lName': lastNameController.text,
          'username': usernameController.text,
          'phone': phoneNumberController.text,
          'emailSignUp': emailController.text,
          'passSignUp': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        var bodyError = responseBody['error'];
        var bodySuccess = responseBody['success'];
        print(bodySuccess);
        if (bodyError != "" && bodyError != null) {
          setState(() {
            errorMessage = bodyError;
          });
          print(errorMessage);
        } else if (bodySuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(),
            ),
          );
        }
      } else {
        print('Error: ${response.reasonPhrase}');
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
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.fromLTRB(width(20), 0, width(20), width(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height(90)),
                      child: Text(
                        'Let\'s get Started',
                        style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'First name',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your First name';
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'First name must contain only alphabetic characters';
                        } else if (value.length < 3 || value.length > 60) {
                          return 'First name must be 3 to 60 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'Last name',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Last name';
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Last name must contain only alphabetic characters';
                        } else if (value.length < 3 || value.length > 60) {
                          return 'Last name must be 3 to 60 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastName = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'User name',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your User name';
                        } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                          return 'User name must contain alphabetic characters or numbers';
                        } else if (value.length < 5 || value.length > 40) {
                          return 'User name must be 3 to 60 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                        counterText: '',
                      ),
                      maxLength: 8,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Phone number must contain only numbers';
                        } else {
                          int? phoneNumber = int.tryParse(value);
                          if (phoneNumber == null ||
                              phoneNumber < 20000000 ||
                              phoneNumber > 99999999) {
                            return 'Phone number doesn\'t exist';
                          }
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _phoneNumber = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 10),
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
                          if (_password == null || value != _password) {
                            return 'Passwords do not match';
                          }
                        }
                        return null;
                      },
                      obscureText: true,
                      onSaved: (value) {
                        _confirmPassword = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFF1EED0),
                        backgroundColor:
                            const Color(0xFF599068), // button's shape
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailVerif(),
                            ),
                          );
                        }
                        signUp(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(width(13)),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      errorMessage, // Display the error message
                      style: TextStyle(
                        color: Colors.red, // Set text color to red
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You already have an account?',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(16),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogIn(),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: const Color(0xff599068),
                              fontSize: width(16),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Image.asset('assets/images/google.png'),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Sign Up with Google',
                                    style: TextStyle(
                                      color: const Color(0xFFF1EED0),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
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
