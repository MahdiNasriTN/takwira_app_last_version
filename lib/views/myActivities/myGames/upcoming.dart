import 'package:flutter/material.dart';
import 'package:takwira_app/views/cards/game_card.dart';
import 'package:takwira_app/views/create/create_game.dart';
import 'package:takwira_app/views/games/game_details.dart';

class Upcoming extends StatelessWidget {
  final dynamic? upcomingGames;
  const Upcoming({super.key, required this.upcomingGames});

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    double sizedBoxWidth = screenWidth < 500 ? width(60) : 69.76744186046512;

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
            'Upcoming Games',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(20)),
          child: Column(
            children: [
              SizedBox(height: width(15)),
              Column(
                children: List.generate(
                  upcomingGames.length,
                  (index) {
                    final game = upcomingGames[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameDetails(gameDataS : game),
                              ),
                            );
                          },
                          child: Ink(child: GameCard(game: true, gameDataS : game)),
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
