import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/auth/forgotPassword/forgot_password.dart';
import 'package:takwira_app/auth/sign_up.dart';
import 'package:takwira_app/views/navigation/navigation.dart';

class LogIn extends StatefulWidget {
  final String? str;
  const LogIn({Key? key , this.str});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  String? successMessage;
  void initState() {
    super.initState();
    print(widget.str);
    if(widget.str != null && widget.str != ""){
      setState(() {
        successMessage = widget.str;
      });
    }
  }
  final formKey = GlobalKey<FormState>();
  late String _logIn;
  String? _password;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> signIn(BuildContext context, String? Pass, String? Email) async {
    final String? email = Email;
    final String? password = Pass;

    final Uri url = Uri.parse('https://takwira.me/login');
    final http.Response response = await http.post(
      url,
      headers: {
        'flutter': 'true',
      },
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodyError = responseBody['error'];
      var bodySuccess = responseBody['success'];
      if (bodyError != "" && bodyError != null) {
        setState(() {
          errorMessage = bodyError;
        });
        print(errorMessage);
      } else if (bodySuccess) {
        var user = responseBody['user'];
        var token = responseBody['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user['username']);
        await prefs.setString('id', user['_id']);
        await prefs.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Navigation(index: 2),
          ),
        );
      }
    } else {
      setState(() {
        errorMessage = 'Invalid username or password.';
      });
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
          Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.fromLTRB(width(20), 0, width(20), width(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height(230)),
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Color(0xFFF1EED0),
                          fontSize: width(32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: width(80)),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFFF1EED0)),
                      decoration: InputDecoration(
                        hintText: 'Username or email or phone number',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBEBCA5),
                          fontSize: width(16),
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your User name, Email, or Phone number';
                        } else if (!isUsername(value) &&
                            !isEmail(value) &&
                            !isPhoneNumber(value)) {
                          return 'Please enter a valid User name, Email, or Phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _logIn = value!;
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Color(0xFFF1EED0),
                          fontSize: width(16),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFFF1EED0),
                        backgroundColor: Color(0xFF599068),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          signIn(context, _password, _logIn);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(width(13)),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width(20),
                          ),
                        ),
                      ),
                    ),
                    if(errorMessage != "")
                      const SizedBox(height: 20),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    if(successMessage != null)
                      const SizedBox(height: 20),
                      Text(
                        successMessage != null ? successMessage! : "",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: Color(0xFFF1EED0),
                            fontSize: width(16),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            'Register here',
                            style: TextStyle(
                              color: Color(0xFF599068),
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
                                    'Sign In with Google',
                                    style: TextStyle(
                                      color: Color(0xFFF1EED0),
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

  bool isUsername(String value) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value) &&
        !(value.length < 5 || value.length > 40);
  }

  bool isEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool isPhoneNumber(String value) {
    int? phoneNumber = int.tryParse(value);
    return phoneNumber != null &&
        phoneNumber >= 20000000 &&
        phoneNumber <= 99999999;
  }
}
