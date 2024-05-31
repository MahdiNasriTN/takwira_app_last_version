import 'package:flutter/material.dart';
import 'package:takwira_app/views/cards/team_card.dart';
import 'package:takwira_app/views/create/create_team.dart';
import 'package:takwira_app/views/teams/team_details.dart';

class AllMyTeams extends StatelessWidget {
  final dynamic? teams;
  const AllMyTeams({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double sizedBoxWidth = screenWidth < 500 ? width(60) : 69.76744186046512;

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      floatingActionButton: SizedBox(
        width: sizedBoxWidth,
        height: sizedBoxWidth,
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
            'My Teams',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(20)),
          child: Column(
            children: [
              SizedBox(height: width(15)),
              Column(
                children: List.generate(
                  teams.length,
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
            ],
          ),
        ),
      ),
    );
  }
}
