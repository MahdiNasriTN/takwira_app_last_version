import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/data/user_data.dart';
import 'package:takwira_app/views/profile/edit_profile_details.dart';

class ProfileDetails extends ConsumerWidget {
  final dynamic? currentUser;
  final VoidCallback toggleEditing;
  const ProfileDetails(
      {super.key, this.currentUser, required this.toggleEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = currentUser;
    final rightFoot = ref.watch(footProvider);

    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(62)),
        child: Column(
          children: [
            SizedBox(height: width(30)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width(70)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width(20)),
                  border: Border.all(color: Color(0xFFF1EED0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(10)),
                  child: IconButton(
                    onPressed: toggleEditing,
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit your details',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(14),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Image.asset(
                          'assets/images/editDetails.png',
                          width: width(14),
                          height: width(14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: width(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Age',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: width(90),
                  child: Text(
                    '${currentUser['age']} Years',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: width(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Height',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: width(90),
                  child: Text(
                    '${profileData['height']} cm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: width(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: width(90),
                  child: Text(
                    '${profileData['weight']} Kg',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: width(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Foot',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                rightFoot == true
                    ? Padding(
                        padding: EdgeInsets.only(right: width(10)),
                        child: Row(
                          children: [
                            Transform.rotate(
                              angle: 30 * (3.141592653589793 / 180),
                              child: Image.asset(
                                'assets/images/right.png',
                                width: width(30),
                                height: width(30),
                              ),
                            ),
                            SizedBox(width: width(10)),
                            Text(
                              'Right',
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(right: width(10)),
                        child: Row(
                          children: [
                            Text(
                              'Left',
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: width(10)),
                            Transform.rotate(
                              angle: -30 * (3.141592653589793 / 180),
                              child: Image.asset(
                                'assets/images/left.png',
                                width: width(30),
                                height: width(30),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            SizedBox(height: width(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jersey Number',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/jerseyNumber.png',
                          width: width(50),
                          height: width(50),
                        ),
                        Positioned(
                          top: width(13),
                          child: SizedBox(
                            width: width(50),
                            child: Text(
                              '${profileData['jerseyNumber']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(16),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width(15)),
                  ],
                ),
              ],
            ),
            SizedBox(height: width(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Primary Position',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: width(80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profileData['preferedPosition'],
                        style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: width(10)),
                      Image.asset(
                        'assets/images/position.png',
                        width: width(18),
                        height: width(18),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: width(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Secondary Positions',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                if (profileData['otherPositions'].isNotEmpty)
                  SizedBox(
                    width: profileData['otherPositions'].length == 1
                        ? width(65)
                        : profileData['otherPositions'].length == 2
                            ? width(80)
                            : width(109),
                    child: Row(
                      children: List.generate(
                        profileData['otherPositions'].length,
                        (index) => Row(
                          children: [
                            Text(
                              profileData['otherPositions'][index],
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (index < (profileData['otherPositions'].length - 1))
                              SizedBox(width: width(10)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
