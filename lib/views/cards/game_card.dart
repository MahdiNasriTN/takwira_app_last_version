import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:takwira_app/data/field_data.dart';
import 'package:takwira_app/data/game_data.dart';
import 'package:takwira_app/views/games/game_details.dart';
import 'package:takwira_app/views/games/played_game_details.dart';

class GameCard extends ConsumerWidget {
  final dynamic? game;
  final dynamic? gameDataS;
  const GameCard({required this.game, required this.gameDataS, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(gameDataProvider);
    bool member = gameDataS['game']['isMember'];

    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      game == true ? a = width / 430 : a = width / 430 * 0.85;
      return screenWidth * a;
    }


    final gameDate = DateTime.parse(gameDataS['game']['date']);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final yesterday = today.subtract(Duration(days: 1));
    final date = gameDate;
    final soon = date.difference(now).inDays;
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    String time = gameData.gameTime.length == 4
        ? '0${gameData.gameTime}'
        : gameData.gameTime;

    final dateTime = DateTime.parse('${date.year}-$month-$day $time');

    details() {
      if (now.isBefore(dateTime)) return GameDetails(gameDataS: gameDataS);
      if (now.isAfter(dateTime)) return PlayedGameDetails();
    }

    if (gameDataS == null) {
      return SizedBox(
        width: width(390),
        height: width(226),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: width(390),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width(2)),
            child: SizedBox(
              width: width(388),
              height: width(226),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/gameBg.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
              ),
            ),
          ),
          Positioned(
            top: width(23),
            child: Container(
              width: width(104),
              height: width(21),
              decoration: BoxDecoration(
                color: const Color(0xFF599068).withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(width(3)),
                  bottomRight: Radius.circular(width(3)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: width(2.5)),
                child: Text(
                  date.isAtSameMomentAs(today)
                      ? 'Today, ${DateFormat.jm().format(dateTime)}'
                      : date.isAtSameMomentAs(yesterday)
                          ? 'Yesterday, ${DateFormat.jm().format(dateTime)}'
                          : date.isAtSameMomentAs(tomorrow)
                              ? 'Tomorrow, ${DateFormat.jm().format(dateTime)}'
                              : date.isAfter(now) && soon < 7
                                  ? '${DateFormat('EEEE').format(date)}, ${DateFormat.jm().format(dateTime)}'
                                  : DateFormat('EEE, d MMM, yyyy').format(date),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(10),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width(62)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(22)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('d MMMM, yyyy').format(date),
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      gameDataS['field'] != null
                          ? gameDataS['field']['name'] ??
                              'Field name not available'
                          : 'Loading...',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width(2)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${gameDataS['field']['price']} DNT',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      '${(gameDataS['field']['distance'] as double).toStringAsFixed(2)} Km away',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width(19)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              'assets/images/profileIcon.png',
                              width: width(34),
                              height: width(40),
                            ),
                            SizedBox(
                              width: width(34),
                              height: width(40),
                              child: Padding(
                                padding: EdgeInsets.all(width(7)),
                                child: Image.asset(
                                  'assets/images/avatar.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: member == false
                            ? gameData.playersNeeded != gameData.members
                                ? const Color(0xFFF1EED0)
                                : const Color(0xFF292929)
                            : const Color(0xFFF1EED0),
                        backgroundColor: member == false
                            ? gameData.playersNeeded != gameData.members
                                ? const Color(0xFF599068)
                                : const Color(0xFF807E73)
                            : const Color(0xFF599068),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(5)),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(10)),
                      ),
                      onPressed: () {
                        Widget? page = details();
                        if (page != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => page,
                            ),
                          );
                        } else {}
                      },
                      child: Text(
                        member == false
                            ? gameData.playersNeeded != gameData.members
                                ? 'Join'
                                : 'Full'
                            : now.isBefore(dateTime)
                                ? 'Details'
                                // : dateTime.difference(now).inMinutes > 90
                                //     ? 'Details'
                                : 'Rate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width(14)),
              SizedBox(
                width: width(390),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(22)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressBar(
                              maxSteps: gameData.playersNeeded,
                              progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                              currentStep: (gameData.playersNeeded -gameDataS['game']['playersLeft']).toInt(),
                              progressColor: const Color(0xff599068),
                              backgroundColor:const Color(0xffF1EED0).withOpacity(0.3),
                            ),
                            SizedBox(height: width(4)),
                            Text(
                              '${(gameData.playersNeeded -gameDataS['game']['playersLeft']).toInt()}',
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontWeight: FontWeight.normal,
                                fontSize: width(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width(18)),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/jerseyNum.png',
                            width: width(24),
                            height: width(24),
                          ),
                          SizedBox(height: width(4)),
                          Text(
                            '${gameData.playersNeeded}',
                            style: TextStyle(
                              color: const Color(0xFFF1EED0),
                              fontWeight: FontWeight.normal,
                              fontSize: width(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
