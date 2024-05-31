import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/messages/chat1.dart';
import 'package:takwira_app/views/messages/chatinterface.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  List<dynamic> allPlayers = [];
  IO.Socket? socket;
  List<dynamic> found = [];
  @override
  void initState() {
    super.initState();
    getAllUsers();
    initSocket();
  }

  void initSocket() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenV = prefs.getString('token') ?? '';
    var usernameV = prefs.getString('username') ?? '';
    var id = prefs.getString('id') ?? '';
    socket = IO.io(
      'https://takwira.me/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'query': {
          'token': tokenV,
          'username': usernameV,
        },
      },
    );

    socket!.onConnect((_) {
      print('Connected to server');
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'New Message',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 17),
                Text(
                  'To',
                  style: TextStyle(
                    color: const Color(0xFFA09F8D),
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: 2000,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: found.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>ChatInterface(user : found[index], socket : socket),
                      ),
                    );
                  },
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
    );
  }
}
