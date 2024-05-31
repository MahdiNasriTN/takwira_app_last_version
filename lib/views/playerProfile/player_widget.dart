import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/cards/profile_card.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserWidget extends StatefulWidget {
  final dynamic? user;
  final IO.Socket? socket;
  final String? id;
  const UserWidget({Key? key, this.user, this.socket,this.id}) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  late Map<String, dynamic> playerData;
  late bool follow;

  @override
  void initState() {
    super.initState();
    playerData = {
      'username': widget.user?['username'],
      'image': widget.user?['image'],
    };
    follow = !widget.user?['followers'].contains(widget.id);
    print(follow);
  }

  void addFollow(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentUserId = prefs.getString('id') ?? '';

    widget.socket?.emit('new-follow', {
      'followerid': currentUserId,
      'receiverid': userId,
    });

    widget.socket?.on('follow_ack', (data) {
      print('Follow request acknowledged: $data');
    });
  }

  void removeFollow(userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentUserId = prefs.getString('id') ?? '';
    print('wawawawa');
    widget.socket?.emit('remove-follow', {
      'followerid': currentUserId,
      'receiverid': userId,
    });

    widget.socket?.on('follow_ack', (data) {
      print('Follow request acknowledged: $data');
    });
  }

  @override
  Widget build(BuildContext context) {
     double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }


    return Row(
      children: [
        SizedBox(width: width(7)),
        Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlayerProfile(playerData: playerData),
                  ),
                );
              },
              child: Ink(
                child: ProfileCard(gameDataS: playerData),
              ),
            ),
            SizedBox(height: width(15)),
            SizedBox(
              width: width(140),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width(7)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: follow
                        ? const Color(0xFFF1EED0)
                        : const Color(0xFF292929),
                    backgroundColor: follow
                        ? const Color(0xFF599068)
                        : const Color(0xFF807E73),
                    padding: EdgeInsets.symmetric(
                        horizontal: width(15), vertical: width(16)),
                  ),
                  onPressed: () {
                    follow ? addFollow(widget.user?['_id']) : removeFollow(widget.user?['_id']);
                    setState(() {
                      follow = !follow;
                    });
                    
                  },
                  child: Text(
                    follow ? 'Follow' : 'Following',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
