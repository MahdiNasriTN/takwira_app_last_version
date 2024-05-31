import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:takwira_app/views/games/game_details.dart';
import 'package:takwira_app/views/teams/team_details.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<dynamic> notifications = [];
  List<dynamic> displayedNotifications = [];
  String? userid;
  IO.Socket? socket;
  int itemsToShow = 10;

  @override
  void initState() {
    super.initState();
    fetchNotificationsData();
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

    socket!.on('new-mobile-join-request', (data) {
    print(data);
      setState(() {
        notifications.insert(0, data);
        updateDisplayedNotifications();
      });
    });

  }

  Future<void> fetchNotificationsData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var id = prefs.getString('id') ?? '';
    var token = prefs.getString('token') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse('https://takwira.me/api/notifications/data?username=$username'),
          headers: {
            'flutter': 'true',
            'authorization': token,
          },
        );
        if (response.statusCode == 200) {
          final dataResponse = jsonDecode(response.body);
          setState(() {
            notifications = dataResponse['notifications'];
            userid = id;
            updateDisplayedNotifications();
          });
        } else {
          print('Failed to fetch user data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch user data: $e');
      }
    }
  }

  void updateDisplayedNotifications() {
    setState(() {
      displayedNotifications = notifications.take(itemsToShow).toList();
    });
  }

  void loadMoreNotifications() {
    setState(() {
      itemsToShow += 10;
      updateDisplayedNotifications();
    });
  }

  @override
  void dispose() {
    socket!.off('new-mobile-messages');
    super.dispose();
  }

  void redirectToTeamOrGame (notification , type)async{
    print(notification);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var id = prefs.getString('id') ?? '';
    var token = prefs.getString('token') ?? '';
    if(type == 1 || type == 2){
      var teamId = notification['teamId'];
      final response = await http.get(
        Uri.parse('https://takwira.me/api/getteam/data?username=$username&teamId=$teamId&type=$type'),
        headers: {
          'flutter': 'true',
          'authorization': token,
          'notification' : jsonEncode(notification)
        },
      );
      if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodySuccess = responseBody['success'];
      if (bodySuccess) {
        var team = responseBody['team'];
        print(team);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamDetails(team: team),
          ),
        );
      }
    }
    }else if(type == 3){
      var gameId = notification['gameId'];
      final response = await http.get(
        Uri.parse('https://takwira.me/api/getgame/data?username=$username&gameId=$gameId&type=$type'),
        headers: {
          'flutter': 'true',
          'authorization': token,
          'notification' : jsonEncode(notification)
        },
      );
      if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodySuccess = responseBody['success'];
      if (bodySuccess) {
        var game = responseBody['game'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetails(gameDataS: game),
          ),
        );
      }
    }

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double radius = screenWidth < 500 ? width(15) : 17.44186046511628;
    double sizedBoxWidth = screenWidth < 500 ? width(50) : 69.76744186046512;
    double activeAdd = screenWidth < 500 ? width(40) : 46.51162790697674;

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: displayedNotifications.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: displayedNotifications.length + 1,
              itemBuilder: (context, index) {
                if (index == displayedNotifications.length) {
                  return displayedNotifications.length < notifications.length
                      ? TextButton(
                          onPressed: loadMoreNotifications,
                          child: Text('See more'),
                        )
                      : SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: width(10)),
                  child: InkWell(
                    onTap: () {
                      if(displayedNotifications[index]['notification']['type'] == 1 ||displayedNotifications[index]['notification']['type'] == 2){
                        redirectToTeamOrGame(displayedNotifications[index]['notification'] , 1);
                      }else{
                        redirectToTeamOrGame(displayedNotifications[index]['notification'] , 3);
                      }
                    },
                    child: Container(
                      color: displayedNotifications[index]['notification']['status'] == false
                          ? Color.fromARGB(255, 60, 59, 59)
                          : Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(width(10)),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              SizedBox(
                                width: width(40),
                                height: width(40),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(width(25)),
                                  child: Image.network(
                                    '${displayedNotifications[index]['owner']['image']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayedNotifications[index]['owner']['username'],
                                style: TextStyle(
                                  color: Color(0xffF1EED0),
                                  fontSize: width(14),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                '${displayedNotifications[index]['notification']['content']}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 179, 179, 179),
                                  fontSize: width(9),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                formatMessageTimestamp(displayedNotifications[index]['notification']['timestamp']),
                                style: TextStyle(
                                  color: Color(0xffBFBCA0),
                                  fontSize: width(10),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

String formatMessageTimestamp(String timestamp) {
  DateTime messageTime = DateTime.parse(timestamp);

  DateTime now = DateTime.now();

  Duration difference = now.difference(messageTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24 && now.day == messageTime.day) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours < 24 && now.day - 1 == messageTime.day) {
    return 'Yesterday at ${messageTime.hour}:${messageTime.minute}';
  } else {
    return '${_getDayName(messageTime.weekday)} ${messageTime.day} ${_getMonthName(messageTime.month)} ${messageTime.year} at ${_formatHour(messageTime.hour)}:${_formatMinute(messageTime.minute)}';
  }
}

String _getDayName(int day) {
  switch (day) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

String _getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

String _formatHour(int hour) {
  if (hour < 10) {
    return '0$hour';
  } else {
    return '$hour';
  }
}

String _formatMinute(int minute) {
  if (minute < 10) {
    return '0$minute';
  } else {
    return '$minute';
  }
}
