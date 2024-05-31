import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Announcement extends StatefulWidget {
  final String? gameid;
  final String? teamid;
  const Announcement({super.key , this.gameid, this.teamid});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  TextEditingController text = TextEditingController();
  List<dynamic> announcements = [];
  bool ?isOwner;
  @override
  void initState() {
    super.initState();
    getAnnouncements();
  }


  void getAnnouncements() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      var token = prefs.getString('token') ?? '';
      Uri url;
      
      if(widget.gameid != null){
        url = Uri.parse('https://takwira.me/api/getgameannouncements?username=$username&gameId=${widget.gameid.toString()}');
      }else{
        url = Uri.parse('https://takwira.me/api/getteamannouncements?username=$username&teamId=${widget.teamid.toString()}');
      }

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
          var bodyAnnouncements = responseBody['announs'];
          setState(() {
            announcements = bodyAnnouncements;
            isOwner = responseBody['isOwner'];
          });
        }
      } 
    }

    void addAnnouncement(String content) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      var token = prefs.getString('token') ?? '';
      print(widget.gameid );
      print(widget.teamid);
      Uri url ;
      if(widget.gameid != null){
        url = Uri.parse('https://takwira.me/api/game/addannoucement?username=$username&gameId=${widget.gameid.toString()}');
      }else{
        url = Uri.parse('https://takwira.me/api/game/addannoucement?username=$username&teamId=${widget.teamid.toString()}');
      }
      
      final http.Response response;

      if (widget.gameid != null) {
      response = await http.post(url, headers: {
        'flutter': 'true',
        'authorization': token,
      }, body: {
        'type': 'game',
        'announcement': content
      });
    } else {
      response = await http.post(url, headers: {
        'flutter': 'true',
        'authorization': token,
      }, body: {
        'type': 'team',
        'announcement': content
      });
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


    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Announcements',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: width(30)),
          Expanded(
            child: ListView.builder(
              itemCount: announcements.length,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(width(20)),
                      child: Container(
                        width: width(306),
                        decoration: BoxDecoration(
                          color: Color(0x447E3C3C), // No background color
                          border: Border.all(
                            color: Color(0xFFF1EED0), // Border color
                            width: width(0), // Border width
                          ),
                          borderRadius: BorderRadius.circular(width(20)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Image.asset(
                              'assets/images/announcementMessage.png',
                              width: width(40),
                              height: width(40),
                            ),
                            SizedBox(height: width(10)),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: width(20)),
                              child: Text(
                                announcements[index],
                                style: const TextStyle(
                                  color: Color(0xFFF1EED0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: width(20)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: width(30)),
                  ],
                );
              },
            ),
          ),
          if (isOwner == true)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                color: Colors.transparent,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xff474D48),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: text,
                              style: const TextStyle(color: Color(0xFFF1EED0)),
                              decoration: const InputDecoration(
                                hintText: 'Add an Announcement ...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFA09F8D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (text.text.isNotEmpty) {
                                  addAnnouncement(text.text);
                                  announcements.add(text.text);
                                  text.clear();
                                }
                              });
                            },
                            icon: Image.asset(
                              'assets/images/send3.png',
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
