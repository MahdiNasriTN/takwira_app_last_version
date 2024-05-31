import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTabIndexProvider = StateProvider<int>((ref) => 0);

class ActivitiesTabBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TabController tabController = DefaultTabController.of(context);

    tabController.addListener(() {
      ref.read(selectedTabIndexProvider.notifier).state = tabController.index;
    });

    final selectedIndex = ref.watch(selectedTabIndexProvider);

    Widget selectedTab(String label, {required bool isSelected}) {
      return Tab(
        icon: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFFF1EED0) : const Color(0xFFBFBCA0),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return SizedBox(
      height: 41,
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
          controller: tabController,
          dividerColor: const Color(0xFF415346),
          indicatorColor: const Color(0xFF599068),
          // onTap: (index) {
          //   ref.read(selectedTabIndexProvider.notifier).state = index;
          // },
          tabs: [
            selectedTab('My Games', isSelected: selectedIndex == 0),
            selectedTab('My Fields', isSelected: selectedIndex == 1),
            selectedTab('My Teams', isSelected: selectedIndex == 2),
          ],
        ),
      ),
    );
  }
}
