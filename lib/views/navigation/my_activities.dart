import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/providers/activities_tabbar.dart';
import 'package:takwira_app/views/create/create_game.dart';
import 'package:takwira_app/views/create/create_team.dart';
import 'package:takwira_app/views/myActivities/myGames/my_games.dart';
import 'package:takwira_app/views/myActivities/myTeams/my_teams.dart';
import 'package:takwira_app/views/myActivities/myFields/my_fields.dart';
import 'package:takwira_app/views/myActivities/my_liked_quickies.dart';
import 'package:takwira_app/views/navigation/fields.dart';
import 'package:takwira_app/views/navigation/navigation.dart';
import 'package:takwira_app/views/profile/profile.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/search.dart';

class MyActivities extends StatefulWidget {
  const MyActivities({super.key});
  @override
  State<MyActivities> createState() => _MyActivitiesState();
}

class _MyActivitiesState extends State<MyActivities> {
  List<dynamic>? playedGames;
  List<dynamic>? upcomingGames;
  List<dynamic>? teams;
  List<dynamic>? opponentTeams;
  List<dynamic>? joinableTeams;
  List<dynamic>? fields;
  List<dynamic>? otherFields;
  @override
  void initState() {
    super.initState();
    fetchActivitiesData();
  }

  Future<void> fetchActivitiesData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http.get(
            Uri.parse('https://takwira.me/api/activities?username=$username'));
        if (response.statusCode == 200) {
          final fieldsResponse = jsonDecode(response.body);
          setState(() {
            fields = fieldsResponse['fields'];
            upcomingGames = fieldsResponse['upcomingGames'];
            playedGames = fieldsResponse['playedGames'];
            teams = fieldsResponse['teams'];
            opponentTeams = fieldsResponse['opponentTeams'];
            joinableTeams = fieldsResponse['joinableTeams'];
            otherFields = fieldsResponse['otherFields'];
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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                      'Book a Field',
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
                      builder: (context) => const Navigation(index: 4),
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
              'My Activities',
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
        body: Column(
          children: [
            ActivitiesTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  MyGames(
                      upcomingGames: upcomingGames, playedGames: playedGames),
                  MyFields(fields: fields, otherFields: otherFields),
                  MyTeams(
                      teams: teams,
                      opponentTeams: opponentTeams,
                      joinableTeams: joinableTeams),
                  MyLikedQuickies(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
