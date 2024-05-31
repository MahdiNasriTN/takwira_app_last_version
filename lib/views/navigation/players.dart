import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/providers/follow.dart';
import 'package:takwira_app/views/cards/profile_card.dart';
import 'package:takwira_app/views/create/create_game.dart';
import 'package:takwira_app/views/create/create_team.dart';
import 'package:takwira_app/views/navigation/navigation.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';
import 'package:takwira_app/views/profile/profile.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:takwira_app/views/search.dart';

class Players extends StatefulWidget {
  const Players({super.key});
  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  List<dynamic>? playersData;
  late String userid;
  List<List<StateNotifierProvider<Follow, bool>>>? followProvidersMatrix;

  @override
  void initState() {
    super.initState();
    fetchPlayersData().then((_) {
      followProvidersMatrix =
          List.generate((playersData!.length), (columnIndex) {
        return List.generate(2, (rowIndex) {
          return StateNotifierProvider<Follow, bool>((ref) {
            return Follow();
          });
        });
      });
    });
  }

  void addFollow(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    var currentUserId = prefs.getString('id') ?? '';

    final IO.Socket socket = IO.io('https://takwira.me/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'token': token, 'username': username},
    });

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('connection', {
        'token': token,
      });
    });

    socket.onConnectError((_) {
      print('Connection error');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.emit('new-follow', {
      'followerid': currentUserId,
      'receiverid': userId,
    });

    socket.on('follow_ack', (data) {
      print('Follow request acknowledged: $data');
    });
  }

  void removeFollow(userId) async {
    print('waywa');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    var currentUserId = prefs.getString('id') ?? '';

    final IO.Socket socket = IO.io('https://takwira.me/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'token': token, 'username': username},
    });

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('connection', {
        'token': token,
      });
    });

    socket.onConnectError((_) {
      print('Connection error');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.emit('remove-follow', {
      'followerid': currentUserId,
      'receiverid': userId,
    });

    socket.on('follow_ack', (data) {
      print('Follow request acknowledged: $data');
    });
  }

  Future<void> fetchPlayersData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var id = prefs.getString('id') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http.get(
            Uri.parse('https://takwira.me/api/players?username=$username'));
        if (response.statusCode == 200) {
          final gamesResponse = jsonDecode(response.body);
          print('wawa ${gamesResponse['users']}');
          setState(() {
            playersData = gamesResponse['users'];
            userid = id;
          });
        } else {
          print('Failed to fetch user data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('those are the players :${playersData}');
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double radius = screenWidth < 500 ? width(15) : 17.44186046511628;
    double sizedBoxWidth = screenWidth < 500 ? width(60) : 69.76744186046512;
    double activeAdd = screenWidth < 500 ? width(50) : 48.13953488372093;

    if (playersData == null) {
      // Show loading indicator
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Players',
              style: TextStyle(
                color: Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            icon: Stack(
              children: [
                Image.asset('assets/images/profileIcon.png'),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/top.png'),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Search(),
                      ),
                    );
                  },
                  icon: Image.asset('assets/images/search.png'),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        floatingActionButton: SizedBox(
          width: sizedBoxWidth,
          height: sizedBoxWidth,
          child: SpeedDial(
            backgroundColor: Colors.transparent,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            children: [
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                ),
                onTap: () {},
              ),
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(14)),
                    child: Text(
                      'Create Game',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGame(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(14)),
                    child: Text(
                      'Create your Team',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTeam(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                labelWidget: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1EED0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(width(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(14)),
                    child: Text(
                      'Book a Field',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Navigation(index: 4),
                    ),
                  );
                },
              ),
            ],
            activeChild: Image.asset(
              'assets/images/add.png',
              width: activeAdd,
              height: activeAdd,
            ),
            child: Image.asset(
              'assets/images/add.png',
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Players',
              style: TextStyle(
                color: Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            icon: Stack(
              children: [
                Image.asset('assets/images/profileIcon.png'),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/top.png'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/search.png'),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(50)),
            child: Column(
              children: [
                SizedBox(height: width(15)),
                Column(
                  children: List.generate(
                    (playersData!.length / 2).ceil(),
                    (rowIndex) => Consumer(
                      builder: (context, ref, _) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                2,
                                (colIndex) {
                                  int playerIndex = rowIndex * 2 + colIndex;
                                  if (playerIndex < playersData!.length) {
                                    final player = playersData![playerIndex];
                                    final playerDatas = {
                                      'username': player['username'],
                                      'image': player['image'],
                                    };

                                    final followed = player['followers'];
                                    var follow = true;
                                    if (followed.contains(userid)) {
                                      follow = false;
                                    }
                                    // final follow = ref.watch(
                                    //     followProvidersMatrix![columnIndex]
                                    //         [rowIndex]);
                                    return Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  width(1.5), 0, 0, width(13)),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlayerProfile(
                                                              playerData:
                                                                  playerDatas),
                                                    ),
                                                  );
                                                },
                                                child: Ink(
                                                    child: ProfileCard(
                                                        gameDataS:
                                                            playerDatas)),
                                              ),
                                            ),
                                            Positioned(
                                              top: width(169.5),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Ink(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/text.png',
                                                        width: width(13.4),
                                                        height: width(12.86),
                                                      ),
                                                      Text(
                                                        'Message',
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFFF1EED0),
                                                          fontSize: width(6),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: width(168),
                                              right: width(2),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Ink(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/invite.png',
                                                        width: width(12.86),
                                                        height: width(12.86),
                                                      ),
                                                      Text(
                                                        'invite',
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFFF1EED0),
                                                          fontSize: width(6),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: follow
                                                  ? width(61.8)
                                                  : width(57.4),
                                              child: InkWell(
                                                onTap: () {
                                                  follow
                                                      ? addFollow(player['_id'])
                                                      : removeFollow(
                                                          player['_id']);
                                                  ref
                                                      .read(followProvidersMatrix![
                                                                  playerIndex]
                                                              [rowIndex]
                                                          .notifier)
                                                      .followPressed();
                                                },
                                                child: Ink(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        follow
                                                            ? 'assets/images/follow.png'
                                                            : 'assets/images/following.png',
                                                        width: width(18),
                                                        height: width(18),
                                                      ),
                                                      Text(
                                                        follow
                                                            ? 'Follow'
                                                            : 'Following',
                                                        style: TextStyle(
                                                          color: follow
                                                              ? const Color(
                                                                  0xFFF1EED0)
                                                              : Color(
                                                                  0xFFAAA799),
                                                          fontSize: width(6),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    // If there are no more services, return an empty SizedBox
                                    return SizedBox();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: width(40)),
                          ],
                        );
                      },
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
}
