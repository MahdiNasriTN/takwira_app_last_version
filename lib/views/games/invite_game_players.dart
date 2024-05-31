import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/games/games.dart';
import 'package:takwira_app/views/teams/teams.dart';

class InviteGamePlayers extends ConsumerStatefulWidget {
  final dynamic? game;
  const InviteGamePlayers({super.key , this.game});

  @override
  ConsumerState<InviteGamePlayers> createState() => _InviteGamePlayersState();
}

class _InviteGamePlayersState extends ConsumerState<InviteGamePlayers> {
  List<dynamic> allPlayers = [];

  List<Map<String, dynamic>> joinedPlayers = [
    {"userName": "Chams69", "name": "Chams Ben Hmouda"},
    {"userName": "Mahdi", "name": "Mahdi Nasri"},
  ];
  
  List<dynamic> found = [];

  @override
  void initState() {
    super.initState();
    initializePlayers();  
    allPlayers.removeWhere((player) => joinedPlayers
        .any((joinedPlayer) => joinedPlayer["userName"] == player["userName"]));
  }

  void initializePlayers() async{
    print(widget.game['game']);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      var token = prefs.getString('token') ?? '';
      Uri url = Uri.parse('https://takwira.me/api/getgame/allplayers/data?username=$username&gameId=${widget.game['game']['id']}');
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
          print(players);
          setState(() {
            found = players;
            allPlayers = players;
          });
        }
      }
  }

  void filter(String onSearch) {
    List<dynamic> results = [];
    if (onSearch.isEmpty) {
      results = allPlayers;
    } else {
      results = allPlayers
          .where((element) =>
              element["fName"]
                  .toString()
                  .toLowerCase()
                  .contains(onSearch.toLowerCase()) ||
              element["username"]
                  .toString()
                  .toLowerCase()
                  .contains(onSearch.toLowerCase()))
          .toList();
    }
    setState(() {
      found = results;
    });
  }

  List<Map<String, dynamic>> selectedPlayers = [];

  void togglePlayerSelection(int index) {
    setState(() {
      if (selectedPlayers.contains(found[index])) {
        selectedPlayers.remove(found[index]);
      } else {
        selectedPlayers.add(found[index]);
      }
    });
  }

  void inviteSelectedPlayers() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      var token = prefs.getString('token') ?? '';
      Uri url = Uri.parse('https://takwira.me/api/invitegameplayers?username=$username&gameId=${widget.game['game']['id']}');
      final http.Response response = await http.post(
        url,
        headers: {
          'flutter': 'true',
          'authorization': token,
        },
        body : {
          'players' : jsonEncode(selectedPlayers) 
        }
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var bodySuccess = responseBody['success'];
        if (bodySuccess) {
          final players = responseBody['players'];
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Games(),
          ),
        );
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: Container(
          color: Colors.transparent,
          height: 28,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Container(
              width: 2000,
              color: Color(0xff474D48),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset('assets/images/searchIcon.png'),
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: TextField(
                        onChanged: (value) => filter(value),
                        style: const TextStyle(
                          color: Color(0xFFF1EED0),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: const Color(0xFFA09F8D),
                            fontSize: 14,
                            fontWeight: FontWeight.w100,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: inviteSelectedPlayers,
            child: const Text(
              'Invite',
              style: TextStyle(
                color: Color(0xFF599068),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: ListView.builder(
        itemCount: found.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => togglePlayerSelection(index),
          child: Column(
            children: [
              Stack(children: [
                ListTile(
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
                            '${found[index]['image']}',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  title: Text(
                    found[index]['username'],
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(found[index]['fName']),
                  subtitleTextStyle: TextStyle(
                    color: const Color(0xFFA09F8D),
                  ),
                ),
                if (selectedPlayers.contains(found[index]))
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff599068).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
              ]),
              SizedBox(height: 3),
            ],
          ),
        ),
      ),
    );
  }
}
