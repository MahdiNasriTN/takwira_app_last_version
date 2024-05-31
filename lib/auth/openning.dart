import 'package:flutter/material.dart';
import 'package:takwira_app/auth/log_in.dart';
import 'package:takwira_app/auth/sign_up.dart';

class Opening extends StatelessWidget {
  const Opening({super.key});

  @override
  Widget build(BuildContext context) {
    double a;
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
          Image.asset(
            'assets/images/smoke.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.15),
          ),
          Row(
            children: [
              SizedBox(
                width: width(60),
              ),
              Container(
                margin: screenWidth < 500
                    ? EdgeInsets.only(top: height(10))
                    : EdgeInsets.fromLTRB(0, width(5), 0, width(75)),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: width(308),
                  height: height(353),
                ),
              ),
              SizedBox(width: width(60)),
            ],
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
          Container(
            margin: screenWidth < 500
                ? EdgeInsets.fromLTRB(width(130), 0, width(130), height(50))
                : EdgeInsets.fromLTRB(height(130), 0, height(130), height(50)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFF1EED0),
                    backgroundColor: const Color(0xFF599068), // button's shape
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogIn(str : null),
                      ),
                    );
                  },
                  child: Padding(
                    padding: screenWidth < 500
                        ? EdgeInsets.all(width(13))
                        : EdgeInsets.all(height(13)),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height(13)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFF1EED0),
                    backgroundColor: const Color(0xFF598690), // button's shape
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: screenWidth < 500
                        ? EdgeInsets.all(width(13))
                        : EdgeInsets.all(height(13)),
                    child: Text(
                      'Sign Up',
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
        ],
      ),
    );
  }
}
