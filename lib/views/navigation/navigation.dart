import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/providers/activities_navigation_notifier.dart';
import 'package:takwira_app/providers/fields_navigation_notifier.dart';
import 'package:takwira_app/providers/home_navigation_notifier.dart';
import 'package:takwira_app/providers/players_navigation_notifier.dart';
import 'package:takwira_app/providers/quickies_navigation_notifier.dart';
import 'package:takwira_app/views/navigation/fields.dart';
import 'package:takwira_app/views/navigation/home.dart';
import 'package:takwira_app/views/navigation/my_activities.dart';
import 'package:takwira_app/views/navigation/players.dart';
import 'package:takwira_app/views/navigation/quickies.dart';

class Navigation extends ConsumerWidget {
  final int index;
  const Navigation({super.key, required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickies = ref.watch(quickiesNavigationNotifierProvider) as int;
    final activities = ref.watch(activitiesNavigationNotifierProvider) as int;
    final home = ref.watch(homeNavigationNotifierProvider) as int;
    final players = ref.watch(playersNavigationNotifierProvider) as int;
    final fields = ref.watch(fieldsNavigationNotifierProvider) as int;

    return Scaffold(
      body: IndexedStack(
        index: index == 0
            ? quickies
            : index == 1
                ? activities
                : index == 2
                    ? home
                    : index == 3
                        ? players
                        : fields,
        children: const [
          Quickies(),
          MyActivities(),
          Home(),
          Players(),
          Fields(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xff354038).withOpacity(1),
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
              selectedIcon: Image.asset('assets/images/inQuickies.png'),
              icon: Image.asset('assets/images/quickies.png'),
              label: ''),
          NavigationDestination(
              selectedIcon: Image.asset('assets/images/inActivities.png'),
              icon: Image.asset('assets/images/myActivities.png'),
              label: ''),
          NavigationDestination(
              selectedIcon: Image.asset('assets/images/inHome.png'),
              icon: Image.asset('assets/images/home.png'),
              label: ''),
          NavigationDestination(
              selectedIcon: Image.asset('assets/images/inPlayers.png'),
              icon: Image.asset('assets/images/players.png'),
              label: ''),
          NavigationDestination(
              selectedIcon: Image.asset('assets/images/inFields.png'),
              icon: Image.asset('assets/images/fields.png'),
              label: ''),
        ],
        selectedIndex: index == 0
            ? quickies
            : index == 1
                ? activities
                : index == 2
                    ? home
                    : index == 3
                        ? players
                        : fields,
        onDestinationSelected: (value) {
          index == 0
              ? ref
                  .read(quickiesNavigationNotifierProvider.notifier)
                  .setSelectedIndex(value)
              : index == 1
                  ? ref
                      .read(activitiesNavigationNotifierProvider.notifier)
                      .setSelectedIndex(value)
                  : index == 2
                      ? ref
                          .read(homeNavigationNotifierProvider.notifier)
                          .setSelectedIndex(value)
                      : index == 3
                          ? ref
                              .read(playersNavigationNotifierProvider.notifier)
                              .setSelectedIndex(value)
                          : ref
                              .read(fieldsNavigationNotifierProvider.notifier)
                              .setSelectedIndex(value);
        },
      ),
    );
  }
}