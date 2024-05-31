import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/data/user_data.dart';

class ProfileCard extends ConsumerWidget {
  final dynamic? gameDataS;
  const ProfileCard({super.key, required this.gameDataS});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(userDataProvider);
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    

    return Stack(
      children: [
        Image.asset(
          'assets/images/profile.png',
          width: width(140),
          height: width(200),
        ),
        Positioned(
          top: width(20.66),
          left: width(54),
          child: ClipOval(
            child: Image.network(
              gameDataS['image'],
              width: width(70),
              height: width(66),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width(26.5)),
          child: Column(
            children: [
              SizedBox(height: width(34)),
              Row(
                children: [
                  SizedBox(
                    width: width(19),
                    child: Text(
                      textAlign: TextAlign.center,
                      '${profileData.rate}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: width(19),
                    child: Text(
                      profileData.post,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(9),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width(9)),
              Row(
                children: [
                  SizedBox(
                    width: width(19),
                    child: Image.asset(
                      'assets/images/tunisia.png',
                      width: width(16),
                      height: width(12),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: width(109),
          child: SizedBox(
            width: width(140),
            child: Center(
              child: Text(
                gameDataS['username'],
                style: TextStyle(
                  color: const Color(0xFFF1EED0),
                  fontSize: width(10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
