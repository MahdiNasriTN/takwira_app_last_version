import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/cards/team_card.dart';
import 'package:takwira_app/views/create/create_team.dart';
import 'package:takwira_app/views/search.dart';
import 'package:takwira_app/views/teams/team_details.dart';
import 'package:http/http.dart' as http;

class Teams extends StatefulWidget {
  final bool? isJoinables;
  final bool? isOpponent;
  final dynamic? opponentTeams;
  final dynamic? joinableTeams;
  const Teams(
      {super.key,
      this.isJoinables,
      this.isOpponent,
      this.opponentTeams,
      this.joinableTeams});
  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  List<dynamic>? teams;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isJoinables == true || widget.isOpponent == true) {
      if (widget.isOpponent == true) {
        setState(() {
          teams = widget.opponentTeams;
          isLoading = false;
        });
      } else {
        setState(() {
          teams = widget.joinableTeams;
          isLoading = false;
        });
      }
    } else {
      fetchTeamsData();
    }
  }

  Future<void> fetchTeamsData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http
            .get(Uri.parse('https://takwira.me/api/teams?username=$username'));
        if (response.statusCode == 200) {
          final fieldsResponse = jsonDecode(response.body);
          setState(() {
            teams = fieldsResponse['teams'];
            isLoading = false;
          });
        } else {
          print('Failed to fetch user data: ${response.statusCode}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Failed to fetch user data: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      double a = 0;
      double screenWidth = MediaQuery.of(context).size.width;
      double width(double width) {
        a = width / 430;
        return screenWidth * a;
      }

      double sizedBoxHeight = screenWidth < 500 ? width(60) : 69.76744186046512;
      double sizedBoxWidth = screenWidth < 500 ? width(53) : 61.62790697674419;
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        floatingActionButton: SizedBox(
          width: sizedBoxWidth,
          height: sizedBoxHeight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTeam(),
                ),
              );
            },
            child: Ink(
              child: Image.asset('assets/images/addTeam.png'),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Teams',
              style: TextStyle(
                color: Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(21)),
            child: Column(
              children: [
                SizedBox(height: width(15)),
                Column(
                  children: List.generate(
                    teams!.length,
                    (index) {
                      final team = teams![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetails(team: team),
                                ),
                              );
                            },
                            child: Ink(
                                child: TeamCard(team: true, teamData: team)),
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
