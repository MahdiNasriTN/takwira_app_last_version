import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:takwira_app/data/chat_data.dart';
import 'package:takwira_app/data/user_data.dart';
import 'package:takwira_app/providers/messages_tabbar.dart';
import 'package:takwira_app/views/messages/chat1.dart';
import 'package:takwira_app/views/messages/chat2.dart';
import 'package:takwira_app/views/messages/create_group.dart';
import 'package:takwira_app/views/messages/groups_chat.dart';
import 'package:takwira_app/views/messages/new_messages.dart';
import 'package:takwira_app/views/messages/players_chat.dart';

class Messages extends ConsumerStatefulWidget {
  const Messages({super.key});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<Messages> {
  List chats = [];
  @override
  Widget build(BuildContext context) {
    // final userData = ref.watch(userDataProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double radius = screenWidth < 500 ? width(15) : 17.44186046511628;
    double sizedBoxWidth = screenWidth < 500 ? width(50) : 69.76744186046512;
    double activeAdd = screenWidth < 500 ? width(40) : 46.51162790697674;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(14)),
                    child: Text(
                      'New message',
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
                      builder: (context) => const NewMessage(),
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
                      'Create a Group',
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
                      builder: (context) => const CreateGroup(),
                    ),
                  );
                },
              ),
            ],
            activeChild: Image.asset(
              'assets/images/addMessage.png',
              width: activeAdd,
              height: activeAdd,
            ),
            child: Image.asset(
              'assets/images/addMessage.png',
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Messages',
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
            MessagesTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  PlayersChat(),
                  GroupsChat(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
