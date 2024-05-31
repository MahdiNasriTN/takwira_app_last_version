import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/cards/game_card.dart';
import 'package:takwira_app/views/create/create_game.dart';
import 'package:takwira_app/views/games/game_details.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/search.dart';

class Games extends StatefulWidget {
  const Games({Key? key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  List<dynamic>? games;
  bool isLoading = true; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    fetchGamesData();
  }

  Future<void> fetchGamesData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http
            .get(Uri.parse('https://takwira.me/api/games?username=$username'));
        if (response.statusCode == 200) {
          final gamesResponse = jsonDecode(response.body);
          setState(() {
            games = gamesResponse['games'];
            isLoading = false;
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
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double sizedBoxWidth = screenWidth < 500 ? width(60) : 69.76744186046512;

    // Check if games data is null or loading
    if (games == null || isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        body: Center(
          child: CircularProgressIndicator(), // Show a loading indicator
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      floatingActionButton: SizedBox(
        width: sizedBoxWidth,
        height: sizedBoxWidth,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateGame(),
              ),
            );
          },
          child: Ink(
            child: Image.asset('assets/images/addGame.png'),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Games',
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
              Column(
                children: List.generate(
                  games!.length,
                  (index) {
                    final game = games?[index];
                    return Column(
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
                            child: GameCard(game: true, gameDataS: game),
                          ),
                        ),
                        SizedBox(height: width(15)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
