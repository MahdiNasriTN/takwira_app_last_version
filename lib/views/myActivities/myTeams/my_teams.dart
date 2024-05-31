import 'package:flutter/material.dart';
import 'package:takwira_app/views/cards/team_card.dart';
import 'package:takwira_app/views/myActivities/myTeams/all_my_teams.dart';
import 'package:takwira_app/views/teams/team_details.dart';
import 'package:takwira_app/views/teams/teams.dart';

class MyTeams extends StatelessWidget {
  final dynamic? teams;
  final dynamic? joinableTeams;
  final dynamic? opponentTeams;
  const MyTeams({super.key, required this.teams, required this.opponentTeams, required this.joinableTeams});

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: List.generate(
              teams.length, // badlha beli theb yy chams
              (index) {
                final team = teams[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamDetails(team : team),
                          ),
                        );
                      },
                      child: Ink(child: TeamCard(team: true, teamData: team)),
                    ),
                    SizedBox(height: width(15)),
                  ],
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllMyTeams(teams : teams),
                ),
              );
            },
            child: Text(
              'See more',
              style: TextStyle(
                  color: const Color(0xFFF1EED0),
                  fontSize: width(12),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Find an apponent',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Teams(isOpponent : true , isJoinables : false, opponentTeams : opponentTeams),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(10),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
          SizedBox(height: width(10)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Row(
                  children: List.generate(
                    opponentTeams.length, // Badlha beli theb yy chams
                    (index) {
                      final team = opponentTeams[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetails(team : team),
                                ),
                              );
                            },
                            child: Ink(child: TeamCard(team: false, teamData: team)),
                          ),
                          SizedBox(width: width(11)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width(25)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Join a Team',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Teams(isOpponent : false , isJoinables : true, joinableTeams : joinableTeams),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width(10)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Row(
                  children: List.generate(
                    joinableTeams.length, // badlha beli theb yy chams
                    (index) {
                      final team = joinableTeams[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetails(team : team),
                                ),
                              );
                            },
                            child: Ink(child: TeamCard(team: false, teamData: team)),
                          ),
                          SizedBox(width: width(11)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width(25)),
        ],
      ),
    );
  }
}
