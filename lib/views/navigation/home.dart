import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/providers/follow.dart';
import 'package:takwira_app/views/cards/field_card.dart';
import 'package:takwira_app/views/cards/game_card.dart';
import 'package:takwira_app/views/cards/profile_card.dart';
import 'package:takwira_app/views/create/create_game.dart';
import 'package:takwira_app/views/create/create_team.dart';
import 'package:takwira_app/views/fieldProfile/field_profile.dart';
import 'package:takwira_app/views/games/game_details.dart';
import 'package:takwira_app/views/games/games.dart';
import 'package:takwira_app/views/navigation/navigation.dart';
import 'package:takwira_app/views/notifications/notifications.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';
import 'package:takwira_app/views/profile/profile.dart';
import 'package:takwira_app/views/search.dart';
import 'package:takwira_app/views/teams/teams.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/messages/messages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:takwira_app/views/playerProfile/player_widget.dart';

class ShowText extends StateNotifier<bool> {
  ShowText() : super(false);
  void textTrue() {
    state = true;
  }

  void textfalse() {
    state = false;
  }
}

final showTextProvider = StateNotifierProvider<ShowText, bool>(((ref) {
  return ShowText();
}));

final followProviders1 = List.generate(10, (index) {
  return StateNotifierProvider.autoDispose<Follow, bool>((ref) {
    return Follow();
  });
});

final followProviders2 = List.generate(10, (index) {
  return StateNotifierProvider.autoDispose<Follow, bool>((ref) {
    return Follow();
  });
});

final usernameProvider = FutureProvider<String>((ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? '';
});

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late IO.Socket socket;

  String? userid;
  int? notificationsCount;
  @override
  void initState() {
    super.initState();
    setUserNotificationsCount();
    initSocket();
  }

  void initSocket() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    var currentUserId = prefs.getString('id') ?? '';
    setState(() {
      userid = currentUserId;
    });
    socket = IO.io('https://takwira.me/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {
        'token': token,
        'username': username,
      },
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

    socket.on('update-notif-count', (data) {
      setState(() {
        notificationsCount = data;
      });
    });
  }

  void setUserNotificationsCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id') ?? '';
    String? username = prefs.getString('username') ?? '';
    final currentUserDataResponse = await http.get(
      Uri.parse('https://takwira.me/api/currentuser?username=$username'),
    );

    final currentUserData = jsonDecode(currentUserDataResponse.body);
    setState(() {
      notificationsCount = currentUserData['currentUser']['notifCount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsyncValue = ref.watch(usernameProvider);
    final String? id;
    return FutureBuilder<Map<String, List<dynamic>>>(
      future: fetchData(usernameAsyncValue),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final games = snapshot.data!['games'];
          final fields = snapshot.data!['fields'];
          final users = snapshot.data!['users'];
          final fieldsData = snapshot.data!['fieldsData'];
          final id = snapshot.data!['id'];
          return _buildHomeUI(
              context, ref, games, fields, users, fieldsData, id);
        }
      },
    );
  }

  Future<Map<String, List<dynamic>>> fetchData(
      AsyncValue<String> usernameAsyncValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id') ?? '';
    if (usernameAsyncValue is AsyncData<String>) {
      final username = usernameAsyncValue.value;
      print('Logged in as: $username');
      try {
        final response = await http.get(
          Uri.parse('https://takwira.me/api/home?username=$username'),
        );

        final fieldsDataResponse = await http.get(
          Uri.parse('https://takwira.me/api/fields?username=$username'),
        );

        final currentUserDataResponse = await http.get(
          Uri.parse('https://takwira.me/api/currentuser?username=$username'),
        );

        if (response.statusCode == 200 &&
            fieldsDataResponse.statusCode == 200) {
          final fieldsData = jsonDecode(fieldsDataResponse.body);
          final data = jsonDecode(response.body);
          final currentUserData = jsonDecode(currentUserDataResponse.body);
          final List<dynamic> games = data['games'];
          final List<dynamic> fields = data['fields'];
          final List<dynamic> users = data['users'];
          // ignore: non_constant_identifier_names
          final List<dynamic> FieldsData = fieldsData['fields'];
          final List<dynamic> idList = [id];
          return {
            'games': games,
            'fields': fields,
            'users': users,
            'fieldsData': FieldsData,
            'id': idList,
          };
        } else {
          print('Failed to retrieve data. Error ${response.statusCode}');
          return {
            'games': [],
            'fields': [],
            'users': [],
            'fieldsData': [],
            'id': []
          };
        }
      } catch (e) {
        print('Failed to retrieve data. Error: $e');
        return {
          'games': [],
          'fields': [],
          'users': [],
          'fieldsData': [],
          'id': [],
        };
      }
    } else {
      return {
        'games': [],
        'fields': [],
        'users': [],
        'fieldsData': [],
        'id': [],
        'currentUser': []
      };
    }
  }

  Widget _buildHomeUI(
      BuildContext context,
      WidgetRef ref,
      List<dynamic>? games,
      List<dynamic>? fields,
      List<dynamic>? users,
      List<dynamic>? fieldsData,
      dynamic id) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    final showText = ref.watch(showTextProvider);
    double radius = screenWidth < 500 ? width(15) : 17.44186046511628;
    double sizedBoxWidth = screenWidth < 500 ? width(60) : 69.76744186046512;
    double activeAdd = screenWidth < 500 ? width(50) : 48.13953488372093;
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
            'Home',
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
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Notifications(),
                    ),
                  );
                },
                icon: Image.asset('assets/images/notifications.png'),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${notificationsCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Messages(),
                ),
              );
            },
            icon: Image.asset('assets/images/chat.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Games(),
                      ),
                    );
                  },
                  child: Ink(
                    child: Image.asset(
                      'assets/images/games.png',
                      width: width(100),
                      height: width(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Teams(),
                      ),
                    );
                  },
                  child: Ink(
                    child: Image.asset(
                      'assets/images/teams.png',
                      width: width(100),
                      height: width(100),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(showTextProvider.notifier).textTrue();

                    Future.delayed(const Duration(seconds: 3), () {
                      ref.read(showTextProvider.notifier).textfalse();
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: showText
                            ? 0.3
                            : 0.4, // Set the opacity of the image
                        child: Image.asset(
                          'assets/images/tournement.png',
                          width: width(100),
                          height: width(100),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: showText ? 0.7 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          'Coming Soon...',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width(25)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Games near you',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Games(),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width(10)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Row(
                  children: List.generate(
                    games!.length,
                    (index) {
                      final game = games[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameDetails(gameDataS: game),
                                ),
                              );
                            },
                            child: Ink(
                                child: GameCard(game: true, gameDataS: game)),
                          ),
                          SizedBox(
                            width: width(11),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width(25)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Players near you',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Navigation(index: 3),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width(10)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                users!.length < 5 ? users!.length : 5,
                (index) =>
                    UserWidget(user: users[index], id: userid, socket: socket),
              ),
            ),
          ),
          SizedBox(height: width(25)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Fields near you',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Navigation(index: 4),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width(10)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Row(
                  children: List.generate(
                    fieldsData!.length < 5
                        ? fieldsData!.length
                        : fieldsData!.length,
                    (index) {
                      final fieldComp = fieldsData[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FieldProfile(field: fieldComp),
                                ),
                              );
                            },
                            child: Ink(
                                child: FieldCard(
                                    field: fieldComp, socket: socket)),
                          ),
                          SizedBox(width: width(11)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
