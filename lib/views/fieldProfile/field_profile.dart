import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/data/field_data.dart';
import 'package:takwira_app/views/cards/field_card.dart';
import 'package:takwira_app/views/fieldProfile/field_booking.dart';
import 'package:takwira_app/views/fieldProfile/field_details.dart';
import 'package:takwira_app/views/fieldProfile/field_posts.dart';
import 'package:takwira_app/views/fieldProfile/field_profile_header.dart';

class FieldProfile extends ConsumerStatefulWidget {
  final dynamic? field;
  const FieldProfile({super.key, required this.field});

  @override
  _FieldProfileState createState() => _FieldProfileState();
}

class _FieldProfileState extends ConsumerState<FieldProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field?['field'];
    final fieldData = ref.watch(fieldDataProvider);
    final loved = ref.watch(loveProvider);
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

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            field['name'],
            style: const TextStyle(
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
                  ref.read(loveProvider.notifier).lovePressed();
                },
                icon: Image.asset(
                  loved == false
                      ? 'assets/images/love.png'
                      : 'assets/images/loved.png',
                  height: width(22),
                  width: width(22),
                ),
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
                  FieldProfileHeader(
                    field: field,
                    onBookNowPressed: () {
                      setState(() {
                        selectedIndex = 2;
                        _tabController.animateTo(2);
                      });
                    },
                  ),
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
                            'assets/images/fieldDetailsS.png',
                            'assets/images/fieldDetails.png',
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
                            'assets/images/bookS.png',
                            'assets/images/book.png',
                            isSelected: selectedIndex == 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(controller: _tabController, children: [
                FieldDetails(field: field),
                FieldPosts(),
                FieldBooking(field : field),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
