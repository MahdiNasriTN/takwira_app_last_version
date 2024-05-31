import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/messages/messages.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  late String _groupName;

  List<dynamic> allPlayers = [];

  List<dynamic> found = [];
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  void getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    final Uri url =
        Uri.parse('https://takwira.me/api/getallusers?username=$username');
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
        dynamic users = responseBody['users'];
        setState(() {
          allPlayers = users;
          found = allPlayers;
        });
      } else {
        print('error');
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
              element["name"]
                  .toString()
                  .toLowerCase()
                  .contains(onSearch.toLowerCase()) ||
              element["userName"]
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

  void createGroup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    final Uri url =
        Uri.parse('https://takwira.me/api/creategroup?username=$username');
    final http.Response response = await http.post(
      url,
      headers: {
        'flutter': 'true',
        'authorization': token,
      },
      body: {
        'groupName': _groupName,
        'users': jsonEncode(selectedPlayers),
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodySuccess = responseBody['success'];
      print(bodySuccess);
      if (bodySuccess) {
        setState(() {
          errorMessage = "";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Messages(),
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
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Create Group',
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
                  }
                  createGroup();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(20)),
          child: Column(
            children: [
              SizedBox(height: width(15)),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: const TextStyle(color: Color(0xFFF1EED0)),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Enter Group name',
                    hintStyle: TextStyle(
                      color: const Color(0xFFA09F8D),
                      fontSize: width(14),
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Group name';
                    } else if (value.length < 3 || value.length > 60) {
                      return 'Group name must be 3 to 60 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _groupName = value!;
                  },
                ),
              ),
              SizedBox(height: width(30)),
              SizedBox(
                width: screenWidth,
                child: Text(
                  'invite Players',
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
                            padding:
                                EdgeInsets.fromLTRB(0, 0, width(10), width(5)),
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
              SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.82,
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
                                  height:
                                      50, 
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 9, 8, 9),
                                    child: ClipOval(
                                      child: Image.network(
                                        found[index]['image'],
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height:
                                            50,
                                      ),
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
