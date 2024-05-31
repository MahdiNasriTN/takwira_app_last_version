import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:takwira_app/data/field_data.dart';
import 'package:takwira_app/data/game_data.dart';
import 'package:takwira_app/providers/star.dart';
import 'package:takwira_app/views/cards/profile_card.dart';
import 'package:takwira_app/views/games/game_details.dart';
import 'package:takwira_app/views/games/rate_player.dart';
import 'package:takwira_app/views/playerProfile/player_profile.dart';

final starProvider = StateNotifierProvider.autoDispose<Star, int>((ref) {
  return Star();
});

class PlayedGameDetails extends ConsumerWidget {
  const PlayedGameDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(gameDataProvider);
    final fieldData = ref.watch(fieldDataProvider);

    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final date = gameData.gameDateTime;
    final soon = date.difference(now).inDays;
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    String time = gameData.gameTime.length == 4
        ? '0${gameData.gameTime}'
        : gameData.gameTime;

    final dateTime = DateTime.parse('${date.year}-$month-$day $time');

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Played Game details',
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
        child: Column(
          children: [
            SizedBox(height: width(15)),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(21)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width(15)),
                        child: SizedBox(
                          width: width(388),
                          height: width(244),
                          child: Image.asset(
                            'assets/images/gameBg.png',
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(0.6),
                            colorBlendMode: BlendMode.srcOver,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/linear3.png',
                  width: screenWidth,
                  height: width(265),
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    SizedBox(height: width(25)),
                    Center(
                      child: Text(
                        gameData.gameName,
                        style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(20),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      fieldData.fieldName,
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(8)),
                    Text(
                      date.isAtSameMomentAs(today)
                          ? 'Today, ${DateFormat.jm().format(dateTime)}'
                          : date.isAtSameMomentAs(yesterday)
                              ? 'Yesterday, ${DateFormat.jm().format(dateTime)}'
                              : soon < 7
                                  ? '${DateFormat('EEEE').format(date)}, ${DateFormat.jm().format(dateTime)}'
                                  : DateFormat('EEE, d MMM, yyyy').format(date),
                      style: TextStyle(
                        color: const Color(0xffF1EED0),
                        fontWeight: FontWeight.w700,
                        fontSize: width(12),
                      ),
                    ),
                    Text(
                      DateFormat('d MMMM, yyyy').format(date),
                      style: TextStyle(
                        color: const Color(0xffF1EED0),
                        fontWeight: FontWeight.w700,
                        fontSize: width(12),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: width(130)),
                    Row(
                      children: [
                        SizedBox(width: width(41)),
                        Image.asset(
                          'assets/images/profileIcon.png',
                          width: width(27),
                          height: width(33),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width(41)),
                      height: width(1.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffF1EED0).withOpacity(0.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            blurRadius: 100,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(35)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: width(12)),
                              Text(
                                'Game ended',
                                style: TextStyle(
                                  color: const Color(0xffF1EED0),
                                  fontWeight: FontWeight.normal,
                                  fontSize: width(14),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameDetails(gameDataS : null),
                                ),
                              );
                            },
                            child: Text(
                              'View details',
                              style: TextStyle(
                                  color: const Color(0xFF599068),
                                  fontSize: width(12),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: width(0)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: width(12)),
                      Text(
                        'Man of th match',
                        style: TextStyle(
                          color: const Color(0xffF1EED0),
                          fontWeight: FontWeight.bold,
                          fontSize: width(16),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const GameDetails(),
                      //   ),
                      // );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Vote for',
                          style: TextStyle(
                              color: const Color(0xFF599068),
                              fontSize: width(12),
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          ' MOTM ',
                          style: TextStyle(
                              color: const Color(0xFF599068),
                              fontSize: width(12),
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'trophy',
                          style: TextStyle(
                              color: const Color(0xFF599068),
                              fontSize: width(12),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Stack(
              children: [
                Row(
                  children: [
                    SizedBox(width: width(160)),
                    Image.asset(
                      'assets/images/crown.png',
                      width: width(93.16),
                      height: width(90.67),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: width(70)),
                    Row(
                      children: [
                        SizedBox(width: width(144.5)),
                        ProfileCard(gameDataS : null),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: width(70)),
            Text(
              'Rate Game players',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFF1EED0),
                fontWeight: FontWeight.bold,
                fontSize: width(16),
              ),
            ),
            SizedBox(height: width(25)),
            SizedBox(
              height: width(250),
              child: Swiper(
                itemCount: gameData.members - 1,
                layout: SwiperLayout.DEFAULT,
                viewportFraction: 0.55,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Color(0xff929382),
                        activeColor: Color(0xffF1EED0),
                        activeSize: 12,
                        space: 4)),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(48)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlayerProfile(playerData: null),
                          ),
                        );
                      },
                      child: Ink(child: ProfileCard(gameDataS : null)),
                    ),
                  );
                },
              ),
            ),
            RatePlayer(),
            SizedBox(height: width(70)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: width(12)),
                      Text(
                        'Rate ${fieldData.fieldName}',
                        style: TextStyle(
                          color: const Color(0xffF1EED0),
                          fontWeight: FontWeight.bold,
                          fontSize: width(16),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const GameDetails(),
                      //   ),
                      // );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Rate',
                          style: TextStyle(
                              color: const Color(0xFF599068),
                              fontSize: width(12),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            Image.asset(
              'assets/images/fieldBg.png',
              width: width(194),
              height: width(129),
            ),
            SizedBox(height: width(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Consumer(
                  builder: (context, ref, _) {
                    final currentStar = ref.watch(starProvider);
                    return InkWell(
                      onTap: () {
                        ref.read(starProvider.notifier).starFilled(index);
                      },
                      child: Ink(
                        child: Image.asset(
                          index < currentStar
                              ? 'assets/images/starFilled.png'
                              : 'assets/images/star.png',
                          width: width(24),
                          height: width(24),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: width(9)),
            ClipRRect(
              borderRadius: BorderRadius.circular(width(20)),
              child: Container(
                width: width(306),
                color: Color(0xff474D48),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(20)),
                  child: TextField(
                    style: const TextStyle(color: Color(0xFFF1EED0)),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(
                        color: const Color(0xFFA09F8D),
                        fontSize: width(14),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
