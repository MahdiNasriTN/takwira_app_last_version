import 'package:flutter/material.dart';
import 'package:takwira_app/views/cards/game_card.dart';
import 'package:takwira_app/views/games/game_details.dart';
import 'package:takwira_app/views/games/games.dart';
import 'package:takwira_app/views/games/played_game_details.dart';
import 'package:takwira_app/views/myActivities/myGames/played.dart';
import 'package:takwira_app/views/myActivities/myGames/upcoming.dart';

class MyGames extends StatelessWidget {
  final dynamic? upcomingGames;
  final dynamic? playedGames;
  const MyGames({super.key, required this.upcomingGames, required this.playedGames});

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.bold,
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
                        builder: (context) => Upcoming(upcomingGames : upcomingGames),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.w600),
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
                    upcomingGames.length,
                    (index) {
                      final game  = upcomingGames[index];
                      return Row(
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
          SizedBox(height: width(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Played',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.bold,
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
                        builder: (context) => Played(playedGames : playedGames),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.w600),
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
                    playedGames.length,
                    (index) {
                      final game = playedGames[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlayedGameDetails(),
                                ),
                              );
                            },
                            child: Ink(child: GameCard(game: false, gameDataS : game)),
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
          // SizedBox(height: width(25)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 10),
          //       child: Text(
          //         'See other Games',
          //         style: TextStyle(
          //           color: const Color(0xFFF1EED0),
          //           fontSize: width(12),
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(right: 10),
          //       child: TextButton(
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const Games(),
          //             ),
          //           );
          //         },
          //         child: Text(
          //           'See all',
          //           style: TextStyle(
          //               color: const Color(0xFFF1EED0),
          //               fontSize: width(10),
          //               fontWeight: FontWeight.w400),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: width(10)),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       const SizedBox(width: 10),
          //       Row(
          //         children: List.generate(
          //           5,
          //           (index) {
          //             return Row(
          //               children: [
          //                 InkWell(
          //                   // onTap: () {
          //                   //   Navigator.push(
          //                   //     context,
          //                   //     MaterialPageRoute(
          //                   //       builder: (context) => const GameDetails(),
          //                   //     ),
          //                   //   );
          //                   // },
          //                   child: Ink(child: GameCard(game: false, gameDataS : null)),
          //                 ),
          //                 SizedBox(
          //                   width: width(11),
          //                 )
          //               ],
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: width(25)),
        ],
      ),
    );
  }
}
