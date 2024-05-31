import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:takwira_app/views/messages/chat_list.dart';
import 'package:takwira_app/views/messages/sender.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';

class Chat1 extends StatefulWidget {
  const Chat1({super.key});

  @override
  State<Chat1> createState() => _Chat1State();
}

class _Chat1State extends State<Chat1> {
  bool showIcons = true;
  FocusNode focusNode = FocusNode();
  TextEditingController text = TextEditingController();
  String myName = 'UserName1';

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
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
      appBar: AppBar(
        backgroundColor: Color(0xff141815),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerProfile(playerData : null),
              ),
            );
          },
          icon: Row(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/profileIcon.png',
                    width: 34,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      'assets/images/avatar.png',
                      width: 22,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 8),
              Text(
                'UserName1',
                style: TextStyle(
                  color: Color(0xFFF1EED0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/audioCall.png'),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/videoCall.png'),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/chatBg.png',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (_, index) => BubbleSpecialThree(
                    isSender:
                        chatList[index].senderName == myName ? true : false,
                    text: chatList[index].text.toString(),
                    color: chatList[index].senderName == myName
                        ? Color(0xff599068)
                        : Color(0xff3D423E),
                    tail: false,
                    textStyle: TextStyle(
                        color: Color(0xffF1EED0), fontSize: width(16)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: width(10)),
                child: Container(
                  color: Colors.transparent,
                  height: width(50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(width(30)),
                    child: Container(
                      width: width(388),
                      color: Color(0xff474D48),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              showIcons
                                  ? 'assets/images/cam.png'
                                  : 'assets/images/ball4.png',
                              width: width(35),
                              height: width(35),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: text,
                              focusNode: focusNode,
                              style: const TextStyle(color: Color(0xFFF1EED0)),
                              decoration: InputDecoration(
                                hintText: 'type a message',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFA09F8D),
                                  fontSize: width(16),
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  showIcons = value.isEmpty;
                                });
                              },
                            ),
                          ),
                          if (showIcons)
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/images/mic.png',
                                    width: width(27),
                                    height: width(27),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/images/image.png',
                                    width: width(29),
                                    height: width(29),
                                  ),
                                ),
                                SizedBox(width: width(7)),
                              ],
                            )
                          else
                            Padding(
                              padding: EdgeInsets.only(right: width(10)),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    chatList.add(Sender(text.text, myName));
                                    text.text = '';
                                    showIcons = true;
                                    focusNode.requestFocus();
                                  });
                                },
                                icon: Image.asset(
                                  'assets/images/send.png',
                                  width: width(30),
                                  height: width(30),
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
        ],
      ),
    );
  }
}
