import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/cards/field_card.dart';
import 'package:takwira_app/views/create/create_game.dart';
import 'package:takwira_app/views/create/create_team.dart';
import 'package:takwira_app/views/fieldProfile/field_profile.dart';
import 'package:takwira_app/views/profile/profile.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/search.dart';

class Fields extends StatefulWidget {
  const Fields({super.key});

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  List<dynamic>? fields;
  @override
  void initState() {
    super.initState();
    fetchFieldsData();
  }

  Future<void> fetchFieldsData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http
            .get(Uri.parse('https://takwira.me/api/fields?username=$username'));
        if (response.statusCode == 200) {
          final fieldsResponse = jsonDecode(response.body);
          setState(() {
            fields = fieldsResponse['fields'];
          });
        } else {
          print('Failed to fetch user data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch user data: $e');
      }
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

    double radius = screenWidth < 500 ? width(15) : 17.44186046511628;
    double sizedBoxWidth = screenWidth < 500 ? width(60) : 69.76744186046512;
    double activeAdd = screenWidth < 500 ? width(50) : 48.13953488372093;
    if (fields == null) {
      // Show loading indicator
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Fields',
              style: TextStyle(
                color: Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            icon: Stack(
              children: [
                Image.asset('assets/images/profileIcon.png'),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/map.png'),
                ),
                SizedBox(width: width(30)),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/calander.png'),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Search(),
                      ),
                    );
                  },
                  icon: Image.asset('assets/images/search.png'),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        floatingActionButton: SizedBox(
          width: sizedBoxWidth,
          height: sizedBoxWidth,
          child: SpeedDial(
            backgroundColor: Colors.transparent,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            children: [
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                ),
                onTap: () {},
              ),
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(14)),
                    child: Text(
                      'Create Game',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGame(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(14)),
                    child: Text(
                      'Create your Team',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTeam(),
                    ),
                  );
                },
              ),
            ],
            activeChild: Image.asset(
              'assets/images/add.png',
              width: activeAdd,
              height: activeAdd,
            ),
            child: Image.asset(
              'assets/images/add.png',
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Fields',
              style: TextStyle(
                color: Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            icon: Stack(
              children: [
                Image.asset('assets/images/profileIcon.png'),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/map.png'),
                ),
                SizedBox(width: width(30)),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/calander.png'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/search.png'),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(60)),
            child: Column(
              children: [
                SizedBox(height: width(15)),
                Column(
                  children: List.generate(
                    fields!.length,
                    (index) {
                      final field = fields![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FieldProfile(field: field),
                                ),
                              );
                            },
                            child: Ink(
                                child: Stack(
                              children: [
                                FieldCard(field: field),
                              ],
                            )),
                          ),
                          SizedBox(height: width(15)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
