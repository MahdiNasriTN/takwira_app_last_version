import 'package:flutter/material.dart';
import 'package:takwira_app/views/fieldProfile/field_profile.dart';
import 'package:takwira_app/views/games/game_details.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';
import 'package:takwira_app/views/teams/team_details.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map<String, dynamic>> all = [
    {"name": "Chams", "type": "Player"},
    {"name": "Miami", "type": "Field"},
    {"name": "Classico", "type": "Game"},
    {"name": "Avengers", "type": "Team"},
    {"name": "Mahdi", "type": "Player"},
    {"name": "Duo", "type": "Field"},
    {"name": "Derbi", "type": "Game"},
    {"name": "Sfaxiens", "type": "Team"},
    {"name": "ChamsMahdi", "type": "Player"},
    {"name": "Classico", "type": "Field"},
    {"name": "Derbi2", "type": "Game"},
    {"name": "SfaxiensClub", "type": "Team"},
  ];

  List<Map<String, dynamic>> found = [];
  @override
  void initState() {
    found = all;
    super.initState();
  }

  void filter(String onSearch) {
    List<Map<String, dynamic>> results = [];
    if (onSearch.isEmpty) {
      results = all;
    } else {
      results = all
          .where((element) => element["name"]
              .toString()
              .toLowerCase()
              .contains(onSearch.toLowerCase()))
          .toList();
    }
    setState(() {
      found = results;
    });
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
      ),
      body: ListView.builder(
        itemCount: found.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => found[index]['type'] == 'Player'
                    ? PlayerProfile(playerData: null)
                    : found[index]['type'] == 'Field'
                        ? FieldProfile(field: null)
                        : found[index]['type'] == 'Game'
                            ? GameDetails(gameDataS: null)
                            : TeamDetails(team: null),
              ),
            );
          },
          child: ListTile(
            leading: found[index]['type'] == 'Player'
                ? Stack(
                    children: [
                      Image.asset(
                        'assets/images/profileIcon.png',
                        width: 50,
                        // height: 38,
                      ),
                      SizedBox(
                        width: 50,
                        // height: 38,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 9, 8, 10),
                          child: Image.asset(
                            'assets/images/avatar.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
                : found[index]['type'] == 'Field'
                    ? Image.asset(
                        'assets/images/searchField.png',
                        width: 50,
                      )
                    : found[index]['type'] == 'Game'
                        ? Image.asset(
                            'assets/images/searchGame.png',
                            width: 50,
                          )
                        : Image.asset(
                            'assets/images/searchTeam.png',
                            width: 50,
                          ),
            title: Text(
              found[index]['name'],
              style: TextStyle(
                color: const Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(found[index]['type']),
            subtitleTextStyle: TextStyle(
              color: const Color(0xFFA09F8D),
            ),
          ),
        ),
      ),
    );
  }
}
