import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/views/profile/profile_datails.dart';
import 'package:takwira_app/views/profile/profile_header.dart';
import 'package:takwira_app/views/profile/profile_posts.dart';
import 'package:takwira_app/views/profile/profile_quickies.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/profile/edit_profile_details.dart';
import 'package:takwira_app/views/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  dynamic? currentUser;
  int selectedIndex = 0;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
  }

  Future<void> fetchProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    if (username.isNotEmpty) {
      try {
        final response = await http.get(
            Uri.parse('https://takwira.me/api/profile?username=$username'));
        if (response.statusCode == 200) {
          final profileResponse = jsonDecode(response.body);
          setState(() {
            currentUser = profileResponse['user'];
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
  void dispose() {
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    Widget selectedTab(String selected, String dselected,
        {required bool isSelected}) {
      return isSelected
          ? Image.asset(
              selected,
              width: width(32),
              height: width(32),
            )
          : Image.asset(
              dselected,
              width: width(32),
              height: width(32),
            );
    }

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/edit.png'),
                ),
              ],
            )
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xff343835),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfile(currentUser: currentUser),
                      ),
                    );
                  },
                  icon: Image.asset('assets/images/edit.png'),
                ),
                const SizedBox(width: 5),
              ],
            )
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    ProfileHeader(currentUser: currentUser),
                  ]),
                ),
              ];
            },
            body: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: width(41),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF415346),
                            Color(0xff343835),
                          ],
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: const Color(0xFF4E6955),
                        indicatorColor: const Color(0xFFF1EED0),
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        tabs: [
                          Tab(
                            icon: selectedTab(
                              'assets/images/detailsS.png',
                              'assets/images/details.png',
                              isSelected: selectedIndex == 0,
                            ),
                          ),
                          Tab(
                            icon: selectedTab(
                              'assets/images/postsS.png',
                              'assets/images/posts.png',
                              isSelected: selectedIndex == 1,
                            ),
                          ),
                          Tab(
                            icon: selectedTab(
                              'assets/images/videosS.png',
                              'assets/images/videos.png',
                              isSelected: selectedIndex == 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      if (isEditing == false)
                        ProfileDetails(
                          currentUser: currentUser,
                          toggleEditing: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                        )
                      else
                        EditProfileDetails(
                          currentUser: currentUser,
                          toggleEditing: () {
                            setState(() {
                              isEditing = false;
                            });
                          },
                        ),
                      ProfilePosts(),
                      ProfileQuickies(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
