import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/game_data.dart';
import 'package:takwira_app/data/team.data.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';
import 'package:takwira_app/views/teams/teams.dart';

class TeamRequests extends ConsumerStatefulWidget {
  final dynamic? team;
  const TeamRequests({super.key, this.team});

  @override
  ConsumerState<TeamRequests> createState() => _TeamRequestsState();
}

class _TeamRequestsState extends ConsumerState<TeamRequests> {
  List<dynamic> requestedPlayers = [];

  @override
  void initState() {
    super.initState();
    initializeRequestedPlayers();
  }

  void addPlayerToTeam(playerUsername)async{
    print('wawa');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      var token = prefs.getString('token') ?? '';
      Uri url = Uri.parse('https://takwira.me/api/team/acceptplayer/joinrequest?username=$username&teamid=${widget.team['id']}');
      final http.Response response = await http.post(
        url,
        headers: {
          'flutter': 'true',
          'authorization': token,
        },
        body : {
          'username' : playerUsername,
        }
      );
       if (response.statusCode == 200) {
         var responseBody = json.decode(response.body);
         var bodySuccess = responseBody['success'];
         if (bodySuccess) {
            print('wawaxx');
         }
      }
  }

  void initializeRequestedPlayers() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      var token = prefs.getString('token') ?? '';
      Uri url = Uri.parse('https://takwira.me/api/getteamjoinrequests/data?username=$username&teamid=${widget.team['id']}');
      final http.Response response = await http.get(
        url,
        headers: {
          'flutter': 'true',
          'authorization': token,
        },
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var bodySuccess = responseBody['success'];
        if (bodySuccess) {
          final players = responseBody['players'];
          setState(() {
            requestedPlayers = players;
          });
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    final teamData = ref.watch(teamDataProvider);
    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Team Requests',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: requestedPlayers.length,
        itemBuilder: (context, index) => InkWell(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                     leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/profileIcon.png',
                          width: 50,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            '${requestedPlayers[index]['image']}',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                      title: Text(
                        requestedPlayers[index]['username'],
                        style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(requestedPlayers[index]['fName']),
                      subtitleTextStyle: TextStyle(
                        color: const Color(0xFFA09F8D),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFF1EED0),
                          backgroundColor: const Color(0xFF599068),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        onPressed: () {
                          addPlayerToTeam(requestedPlayers[index]['username']);
                          setState(() {
                            requestedPlayers.removeAt(index);
                          });
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFF1EED0),
                          backgroundColor: const Color(0xff474D48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        onPressed: () {
                          setState(() {
                            requestedPlayers.removeAt(index);
                          });
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
