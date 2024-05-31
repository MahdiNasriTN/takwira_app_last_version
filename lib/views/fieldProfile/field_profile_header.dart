import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/data/field_data.dart';
import 'package:takwira_app/providers/follow.dart';
import 'package:takwira_app/views/messages/chat2.dart';

final followProvider = StateNotifierProvider<Follow, bool>(((ref) {
  return Follow();
}));

class FieldProfileHeader extends ConsumerWidget {
  final dynamic? field;
  final VoidCallback onBookNowPressed; // Callback function

  const FieldProfileHeader(
      {super.key, required this.onBookNowPressed, required this.field});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldData = ref.watch(fieldDataProvider);
    final follow = ref.watch(followProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return Stack(
      children: [
        Positioned(
          top: width(13),
          left: width(2),
          child: SizedBox(
            width: width(428),
            height: width(187),
            child: Image.asset(
              'assets/images/fieldCover.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width(2)),
          child: Image.asset(
            'assets/images/linear1.png',
            width: width(426),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(width(2), width(13), width(2), 0),
          child: Image.asset(
            'assets/images/linear2.png',
            width: width(426),
          ),
        ),
        Image.asset(
          'assets/images/fieldProfile.png',
          width: screenWidth,
          height: width(261),
        ),
        Positioned(
          top: width(164),
          left: width(146),
          child: Image.network(
            field['image'],
            fit: BoxFit.cover,
            width: width(134),
            height: width(84),
          ),
        ),
        Column(
          children: [
            SizedBox(height: width(277)),
            Row(
              children: [
                SizedBox(width: width(90)),
                Column(
                  children: [
                    Text(
                      '${fieldData.posts}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Likes',
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
                      '${field['upcomingGamesCount']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Upcoming Games',
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
                      '${field['playedGamesCount']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Played Games',
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
            SizedBox(height: width(37)),
            Row(
              children: [
                SizedBox(width: width(20)),
                Text(
                  field['description'],
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(10),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: width(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width(123),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(9)),
                        ),
                        foregroundColor: follow == true
                            ? Color.fromARGB(255, 65, 134, 83)
                            : const Color(0xFF292929),
                        backgroundColor: follow == true
                            ? Color.fromARGB(255, 199, 195, 164)
                            : const Color(0xFF807E73),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(13)),
                      ),
                      onPressed: () {
                        ref.read(followProvider.notifier).followPressed();
                      },
                      child: follow == true
                          ? Text(
                              'Follow',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: width(13),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width(12),
                                  ),
                                ),
                                SizedBox(width: width(3)),
                                Column(
                                  children: [
                                    SizedBox(height: width(2)),
                                    Image.asset(
                                      'assets/images/followingUp.png',
                                      width: width(12),
                                      height: width(12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    width: width(123),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(9)),
                        ),
                        foregroundColor: const Color(0xFFF1EED0),
                        backgroundColor: const Color(0xFF474D48),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(13)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Chat2(),
                          ),
                        );
                      },
                      child: Text(
                        'Contact US',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width(123),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(9)),
                        ),
                        foregroundColor: const Color(0xFFF1EED0),
                        backgroundColor: const Color(0xFF599068),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(13)),
                      ),
                      onPressed: () {
                        onBookNowPressed();
                      },
                      child: Text(
                        'Book now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width(20)),
          ],
        ),
      ],
    );
  }
}
