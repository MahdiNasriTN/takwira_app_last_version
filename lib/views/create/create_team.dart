import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/providers/switch.dart';
import 'package:takwira_app/views/create/age_group.dart';
import 'package:takwira_app/views/create/number_selector.dart';
import 'package:takwira_app/views/create/position_selector.dart';
import 'package:takwira_app/views/teams/team_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final switchProvider = StateNotifierProvider<Switched, bool>((ref) {
  return Switched();
});

class CreateTeam extends ConsumerStatefulWidget {
  const CreateTeam({super.key});

  @override
  ConsumerState<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends ConsumerState<CreateTeam> {
  String errorMessage = '';
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController teamDescriptionController =
      TextEditingController();
  int selectedIndex = 0;
  int _selectedNumber = 6;
  List<String> selectedPositions = [];
  List<String> availablePositions = [
    'GK',
    'CB',
    'RB',
    'LB',
    'CDM',
    'CM',
    'CAM',
    'RW',
    'LW',
    'ST'
  ];
  List<dynamic> found = [];

  @override
  void initState() {
    fetchTeamCreationData();
    super.initState();
  }

  dynamic? teams, players, userid, fields;

  void fetchTeamCreationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var id = prefs.getString('id') ?? '';
    var token = prefs.getString('token') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://takwira.me/api/game/creation/data?username=$username'),
          headers: {
            'flutter': 'true',
            'authorization': token,
          },
        );
        if (response.statusCode == 200) {
          final gameResponse = jsonDecode(response.body);
          setState(() {
            players = gameResponse['players'];
            userid = id;
            setState(() {
              found = players;
            });
          });
        } else {
          print('Failed to fetch user data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch user data wawa: $e');
      }
    }
  }

  void filter(String onSearch) {
    List<dynamic> results = [];
    if (onSearch.isEmpty) {
      results = players;
    } else {
      results = players
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

  Future<void> createTeam(BuildContext context) async {
    final String teamName = teamNameController.text;
    final String teamDescription = teamDescriptionController.text;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    final Uri url = Uri.parse('https://takwira.me/api/createteam');
    final http.Response response = await http.post(
      url,
      headers: {
        'flutter': 'true',
        'authorization': token,
      },
      body: {
        'teamName': teamName,
        'teamDescription': teamDescription,
        'username': username,
        'players' : jsonEncode(selectedPlayers),
        'token': token
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodySuccess = responseBody['success'];
      print(bodySuccess);
      if (bodySuccess) {
        var team = responseBody['team'];
        print(team);
        setState(() {
          errorMessage = "";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamDetails(team: team),
          ),
        );
      } else {
        setState(() {
          errorMessage =
              "Field Name should be unique , description should not be empty , the invited players should not exceed 6 players.";
        });
      }
    }
  }

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final private = ref.watch(switchProvider);

    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    Widget selectedTab(String selected, {required bool isSelected}) {
      return Text(
        selected,
        style: TextStyle(
          color: isSelected ? const Color(0xFFF1EED0) : const Color(0xFFBFBCA0),
          fontSize: width(12),
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff343835),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Create your Team',
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
                TextButton(
                  onPressed: () {
                    createTeam(context);
                  },
                  child: const Text(
                    'Create',
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
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: width(21)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(21)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: width(28)),
                    Text(
                      'Team name',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: width(10)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: teamNameController,
                            style: const TextStyle(color: Color(0xFFF1EED0)),
                            decoration: InputDecoration(
                              hintText: 'Enter your Team name',
                              hintStyle: TextStyle(
                                color: const Color(0xFFA09F8D),
                                fontSize: width(14),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width(25)),
                    Text(
                      'Description',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: width(10)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: teamDescriptionController,
                            style: const TextStyle(color: Color(0xFFF1EED0)),
                            decoration: InputDecoration(
                              hintText: 'Enter your Team descreption',
                              hintStyle: TextStyle(
                                color: const Color(0xFFA09F8D),
                                fontSize: width(14),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: errorMessage.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width(10),
                            top: width(30)),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: width(14),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: width(65)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No. of players needed',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Replace IconButton with NumberSelector
                        NumberSelector(
                            selectedNumber: _selectedNumber,
                            itemCount: 7,
                            onNumberSelected: (number) {
                              setState(() {
                                _selectedNumber = number;
                              });
                            }),
                      ],
                    ),
                    SizedBox(height: width(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Positions needed',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        PositionSelector(
                          selectedPositions: selectedPositions,
                          availablePositions: availablePositions,
                          onPositionsSelected: (positions) {
                            setState(() {
                              selectedPositions = positions;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: width(59)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age group',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: width(20)),
                        const Expanded(
                          child: AgeGroup(),
                        ),
                        SizedBox(width: width(10)),
                      ],
                    ),
                    SizedBox(height: width(50)),
                    SizedBox(
                      width: screenWidth,
                      child: Text(
                        'invite Players',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFBFBCA0),
                          fontSize: width(14),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: Colors.transparent,
                      height: width(35),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(width(9)),
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
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, width(10), width(5)),
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
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.80,
                child: ListView.builder(
                  itemCount: found.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => togglePlayerSelection(index),
                    child: Column(
                      children: [
                        Stack(children: [
                          ListTile(
                            leading: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/profileIcon.png',
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 9, 8, 9),
                                    child: Image.asset(
                                      'assets/images/avatar.png',
                                      fit: BoxFit.cover,
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
