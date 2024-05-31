import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/team.data.dart';
import 'package:takwira_app/providers/switch.dart';
import 'package:takwira_app/views/create/age_group.dart';
import 'package:takwira_app/views/create/position_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:takwira_app/views/teams/team_details.dart';



final switchProvider = StateNotifierProvider<Switched, bool>((ref) {
  return Switched();
});

class EditTeam extends ConsumerStatefulWidget {
  final dynamic? team;
  const EditTeam({super.key, this.team});

  @override
  ConsumerState<EditTeam> createState() => _EditTeamState();
}

class _EditTeamState extends ConsumerState<EditTeam> {
  final _formKey = GlobalKey<FormState>();
  late String _teamName;
  late String _teamDesc;

  String? imagePath;
  int selectedIndex = 0;
  // int _selectedNumber = 6;

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


  String errorMessage = "";

  void editTeam() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    final Uri url = Uri.parse('https://takwira.me/api/editteam');
    final http.Response response = await http.post(
      url,
      headers: {
        'flutter': 'true',
        'authorization': token,
      },
      body: {
        'teamId' : widget.team['team']['id'],
        'teamName' : _teamName,
        'teamDescription' : _teamDesc,
        'username': username,
        'token': token,
      },
    );
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodySuccess = responseBody['success'];
      if (bodySuccess) {
        var team = responseBody['team'];
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
          errorMessage = "Your should pick a field and correct date";
        });
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
              'Edit your Team',
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      editTeam();
                    }
                  },
                  child: const Text(
                    'Save',
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
              Form(
                key: _formKey,
                child: Padding(
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
                            child: TextFormField(
                              style: const TextStyle(color: Color(0xFFF1EED0)),
                              initialValue: "",
                              decoration: InputDecoration(
                                hintText: 'Enter your Team name',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFA09F8D),
                                  fontSize: width(14),
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                _teamName = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width(20)),
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
                            child: TextFormField(
                              style: const TextStyle(color: Color(0xFFF1EED0)),
                              initialValue: "",
                              decoration: InputDecoration(
                                hintText: 'Enter your Team descreption',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFA09F8D),
                                  fontSize: width(14),
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                _teamDesc = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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