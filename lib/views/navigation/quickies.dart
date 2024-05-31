import 'package:flutter/material.dart';
import 'package:takwira_app/providers/quickies_tabbar.dart';
import 'package:takwira_app/views/profile/profile.dart';
import 'package:takwira_app/views/search.dart';

class Quickies extends StatelessWidget {
  const Quickies({super.key});

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF586A60).withOpacity(0.9),
        appBar: AppBar(
          backgroundColor: const Color(0xff343835),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Quickies',
              style: TextStyle(
                color: Color(0xFFF1EED0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            icon: Stack(
              children: [
                Image.asset('assets/images/profileIcon.png'),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
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
        body: Column(
          children: [
            QuickiesTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Following content')),
                  Center(child: Text('For you content')),
                  Center(child: Text('Live content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
