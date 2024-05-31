import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/user_data.dart';
import 'package:takwira_app/providers/follow.dart';
import 'package:takwira_app/views/cards/profile_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final followProvider = StateNotifierProvider<Follow, bool>(((ref) {
  return Follow();
}));

class PlayerProfileHeader extends ConsumerStatefulWidget {
  final dynamic? playerData;
  final dynamic? user;
  final dynamic? userId;
  final IO.Socket? socket;
  const PlayerProfileHeader(
      {super.key, required this.playerData, required this.user, this.userId,this.socket});

  @override
    ConsumerState<PlayerProfileHeader> createState() => _PlayerProfileHeaderState();
}

class _PlayerProfileHeaderState extends ConsumerState<PlayerProfileHeader>{
  late int followersCount;
  late bool follow;
  @override
  void initState() {
    super.initState();
    final followed = widget.user['user']['followers'];
    follow = followed.contains(widget.userId);
    print(follow);
    followersCount = widget.user!['user']['followers'].length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.user != null) {
      followersCount = widget.user!['user']['followers'].length;
    }
  }

  void makeFollow() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username') ?? '';
  var token = prefs.getString('token') ?? '';

  widget.socket?.emit('new-follow', {
    'followerid': widget.userId,
    'receiverid': widget.user['user']['_id'],
  });

  void handleFollowAckAdd(data) {
    print('Follow request acknowledged: $data');
    setState(() {
      followersCount++;
    });
    widget.socket?.off('follow_ack_add', handleFollowAckAdd);
  }

  widget.socket?.on('follow_ack_add', handleFollowAckAdd);
}

  void removeFollow() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username') ?? '';
  var token = prefs.getString('token') ?? '';

  widget.socket?.emit('remove-follow', {
    'followerid': widget.userId,
    'receiverid': widget.user['user']['_id'],
  });

  void handleFollowAckRm(data) {
    print('Follow request acknowledged: $data');
    setState(() {
      followersCount--;
    });
    widget.socket?.off('follow_ack_rm', handleFollowAckRm);
  }
  widget.socket?.on('follow_ack_rm', handleFollowAckRm);
}

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double a = 0;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }


    return Stack(
      children: [
        SizedBox(
          width: screenWidth,
          height: width(144),
          child: Image.asset(
            'assets/images/coverPhoto.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            SizedBox(height: width(60)),
            Row(
              children: [
                SizedBox(width: width(20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: width(120)),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Rated',
                    //       style: TextStyle(
                    //         color: const Color(0xFFF1EED0),
                    //         fontSize: width(10),
                    //         fontWeight: FontWeight.normal,
                    //       ),
                    //     ),
                    //     Text(
                    //       ' ${profileData.rated} ',
                    //       style: TextStyle(
                    //         color: const Color(0xFFF1EED0),
                    //         fontSize: width(10),
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //     Text(
                    //       'times',
                    //       style: TextStyle(
                    //         color: const Color(0xFFF1EED0),
                    //         fontSize: width(10),
                    //         fontWeight: FontWeight.normal,
                    //       ),
                    //     ),
                    //     SizedBox(width: width(6)),
                    //     Image.asset(
                    //       'assets/images/rateIcon.png',
                    //       width: width(12),
                    //       height: width(12),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: width(6)),
                    // Row(
                    //   children: [
                    //     Text(
                    //       '${profileData.motm} ',
                    //       style: TextStyle(
                    //         color: const Color(0xFFF1EED0),
                    //         fontSize: width(10),
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //     Text(
                    //       'Man Of The Match',
                    //       style: TextStyle(
                    //         color: const Color(0xFFF1EED0),
                    //         fontSize: width(10),
                    //         fontWeight: FontWeight.normal,
                    //       ),
                    //     ),
                    //     SizedBox(width: width(6)),
                    //     Image.asset(
                    //       'assets/images/motmIcon.png',
                    //       width: width(12),
                    //       height: width(12),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                SizedBox(width: width(4)),
                ProfileCard(gameDataS: widget.playerData),
                SizedBox(width: width(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: width(65)),
                    Text(
                      '@ ${widget.user['user']['username']}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(10),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: width(11)),
                    Row(
                      children: [
                        SizedBox(width: width(15)),
                        Text(
                          '${widget.user['playedGames']} ',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(10),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'played Games',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(10),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width(3)),
                    Row(
                      children: [
                        SizedBox(width: width(15)),
                        Text(
                          '${widget.user['upcomingGames']} ',
                          style: TextStyle(
                            color: const Color(0xFFBFBCA0),
                            fontSize: width(10),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'upcoming Games',
                          style: TextStyle(
                            color: const Color(0xFFBFBCA0),
                            fontSize: width(10),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: width(15)),
            Row(
              children: [
                SizedBox(width: width(109)),
                Column(
                  children: [
                    Text(
                      '${widget.user['user']['friends'].length}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Friends',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width(49)),
                Column(
                  children: [
                    Text(
                      '$followersCount',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width(38)),
                Column(
                  children: [
                    Text(
                      '${widget.user['user']['following'].length}',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width(5)),
                    Text(
                      'Following',
                      style: TextStyle(
                        color: const Color(0xFFF1EED0),
                        fontSize: width(12),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: width(37)),
            // Row(
            //   children: [
            //     SizedBox(width: width(20)),
            //     Text(
            //       user['user'][''].bio,
            //       style: TextStyle(
            //         color: const Color(0xFFF1EED0),
            //         fontSize: width(10),
            //         fontWeight: FontWeight.normal,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: width(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width(123),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(9)),
                        ),
                        foregroundColor: follow == false
                            ? const Color(0xFFF1EED0)
                            : const Color(0xFF292929),
                        backgroundColor: follow == false
                            ? const Color(0xFF599068)
                            : const Color(0xFF807E73),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(13)),
                      ),
                      onPressed: () {
                        follow == false ? makeFollow() : removeFollow();
                        print('ahna nzelna aal button');
                        setState(() {
                          follow = !follow;
                        });
                      },
                      child: follow == false
                          ? Text(
                              'Follow',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width(12),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width(12),
                                  ),
                                ),
                                SizedBox(width: width(3)),
                                Column(
                                  children: [
                                    SizedBox(height: width(2)),
                                    Image.asset(
                                      'assets/images/followingUp.png',
                                      width: width(12),
                                      height: width(12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    width: width(123),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(9)),
                        ),
                        foregroundColor: const Color(0xFFF1EED0),
                        backgroundColor: const Color(0xFF474D48),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(13)),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Message',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width(123),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width(9)),
                        ),
                        foregroundColor: const Color(0xFFF1EED0),
                        backgroundColor: const Color(0xFF474D48),
                        padding: EdgeInsets.symmetric(
                            horizontal: width(15), vertical: width(13)),
                      ),
                      onPressed: () {},
                      child: Text(
                        'invite',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: width(20)),
          ],
        ),
      ],
    );
  }
}
