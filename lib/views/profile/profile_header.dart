import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/data/user_data.dart';
import 'package:takwira_app/views/cards/profile_card.dart';

class ProfileHeader extends ConsumerWidget {
  final dynamic? currentUser;
  const ProfileHeader({super.key, this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(userDataProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    var user = {
      'username': currentUser['username'],
      'image': currentUser['image']
    };
    return Stack(
      children: [
        SizedBox(
          width: screenWidth,
          height: width(144),
          child: Image.asset(
            'assets/images/coverPhoto.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            SizedBox(height: width(60)),
            Row(
              children: [
                SizedBox(width: width(20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: width(120)),
                  ],
                ),
                SizedBox(width: width(4)),
                ProfileCard(gameDataS: user),
                SizedBox(width: width(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: width(65)),
                    Text(
                      '@${currentUser['username']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: width(11)),
                    Row(
                      children: [
                        SizedBox(width: width(15)),
                        Text(
                          '${currentUser['playedGames']} ',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(10),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'played Games',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(10),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width(3)),
                    Row(
                      children: [
                        SizedBox(width: width(15)),
                        Text(
                          '${currentUser['upcomingGamesCount']} ',
                          style: TextStyle(
                            color: const Color(0xFFBFBCA0),
                            fontSize: width(10),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'upcoming Games',
                          style: TextStyle(
                            color: const Color(0xFFBFBCA0),
                            fontSize: width(10),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: width(15)),
            Row(
              children: [
                SizedBox(width: width(109)),
                Column(
                  children: [
                    Text(
                      '${currentUser['friends']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Friends',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width(49)),
                Column(
                  children: [
                    Text(
                      '${currentUser['followers']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width(38)),
                Column(
                  children: [
                    Text(
                      '${currentUser['following']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Following',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: width(20)),
          ],
        ),
      ],
    );
  }
}
