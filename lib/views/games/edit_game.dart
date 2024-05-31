import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/game_data.dart';
import 'package:takwira_app/providers/switch.dart';
import 'package:takwira_app/views/cards/field_card.dart';
import 'package:takwira_app/views/create/position_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/games/game_details.dart';

final switchProvider = StateNotifierProvider<Switched, bool>((ref) {
  return Switched();
});

class EditGame extends ConsumerStatefulWidget {
  final dynamic? game;
  const EditGame({super.key, this.game});

  @override
  ConsumerState<EditGame> createState() => _EditGameState();
}

class _EditGameState extends ConsumerState<EditGame> {
  final _formKey = GlobalKey<FormState>();
  late String _gameName;
  late String _gameDesc;
  int selectedField = -1;
  bool isLoading = true;

  String? imagePath;
  int selectedIndex = 0;
  // int _selectedNumber = 14;

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

  dynamic? fields;
  String? userid;
  @override
  void initState() {
    super.initState();
    if (widget.game == null) {
      isLoading = false; 
    } else {
      getFields();
    }
  }

  void getFields() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var id = prefs.getString('id') ?? '';
    var token = prefs.getString('token') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://takwira.me/api/game/creation/data?username=$username'),
          headers: {
            'flutter': 'true',
            'authorization': token,
          },
        );
        if (response.statusCode == 200) {
          final gameResponse = jsonDecode(response.body);
          setState(() {
            fields = gameResponse['fields'];
            userid = id;
            isLoading = false;
          });
        } else {
          print('Failed to fetch user data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch user data wawa: $e');
      }
    }
  }

  DateTime date = DateTime.now();
  bool used = false;

  void showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xff599068), 
              onPrimary: Colors.white, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.white, 
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        date = value!;
      });
    });
    setState(() {
      used = true;
    });
  }

String errorMessage = "";

  void modifyGameInformations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    final Uri url = Uri.parse('https://takwira.me/api/editgame');
    final http.Response response = await http.post(
      url,
      headers: {
        'flutter': 'true',
        'authorization': token,
      },
      body: {
        'fieldId': selectedField != -1 ? fields[selectedField]['field']['id'] : "",
        'username': username,
        'date' : date.toString().split(" ")[0],
        'token': token,
        'gameId' : widget.game['game']['id'],
        'gameTime' : _gameTimeController.text,
      },
    );
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var bodySuccess = responseBody['success'];
      if (bodySuccess) {
        var game = responseBody['game'];
        setState(() {
          errorMessage = "";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetails(gameDataS: game),
          ),
        );
      } else {
        setState(() {
          errorMessage = "Your should pick a field and correct date";
        });
      }
    }
  }

  final TextEditingController _gameTimeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    if (widget.game == null || isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final private = ref.watch(switchProvider);
    final gameData = ref.watch(gameDataProvider);
    List<String> selectedPositions = gameData.positionsNeeded;

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
              'Edit Game',
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
                      modifyGameInformations();
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
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: width(21)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: width(28)),
                      Text(
                        'Game Time',
                        style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: width(21)),
                              child: TextField(
                                controller: _gameTimeController,
                                style:const TextStyle(color: Color(0xFFF1EED0)),
                                decoration: InputDecoration(
                                  hintText: 'Enter Game Time (Format - 20:20 Exp)',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFA09F8D),
                                    fontSize: width(14),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width(50)),
                      Text(
                        'Location',
                        style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: width(10)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            fields.length,
                            (index) {
                              final field = fields[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedField =
                                        selectedField == index ? -1 : index;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        FieldCard(field : field),
                                        if (selectedField == index)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: width(2)),
                                            child: Container(
                                              width: width(306.59),
                                              height: width(177),
                                              decoration: BoxDecoration(
                                                color: Color(0xff599068)
                                                    .withOpacity(0.25),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width(15)),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(width: width(11)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: width(30)),
                      Padding(
                        padding: EdgeInsets.only(right: width(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  used == false
                                      ? gameData.gameDateTime
                                          .toString()
                                          .split(" ")[0]
                                      : date.toString().split(" ")[0],
                                  style: TextStyle(
                                    color: const Color(0xFFF1EED0),
                                    fontSize: width(12),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: width(8)),
                                IconButton(
                                  onPressed: showDate,
                                  icon: Image.asset(
                                    'assets/images/date.png',
                                    width: width(16),
                                    height: width(16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width(30)),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'No. of players needed',
                      //       style: TextStyle(
                      //         color: const Color(0xFFF1EED0),
                      //         fontSize: width(14),
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //     NumberSelector(
                      //         selectedNumber: _selectedNumber,
                      //         itemCount: 15,
                      //         onNumberSelected: (number) {
                      //           setState(() {
                      //             _selectedNumber = number;
                      //           });
                      //         }),
                      //   ],
                      // ),
                      // SizedBox(height: width(15)),
                      Padding(
                        padding: EdgeInsets.only(right: width(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Positions needed',
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            PositionSelector(
                              selectedPositions: selectedPositions,
                              availablePositions: availablePositions,
                              onPositionsSelected: (positions) {
                                setState(() {
                                  selectedPositions = positions;
                                });
                              },
                            ),
                          ],
                        ),
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