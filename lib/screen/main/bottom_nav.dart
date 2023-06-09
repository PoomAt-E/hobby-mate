import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/chat/chatlist_screen.dart';
import 'package:hobby_mate/screen/class/class_list_%20screen.dart';
import 'package:hobby_mate/screen/community/community_screen.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/screen/main/home_screen.dart';
import 'package:hobby_mate/screen/match/MenteeScreen.dart';
import 'package:hobby_mate/screen/match/MentorScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bottomNavProvider = StateProvider<int>((ref) => 0);
final roleStateProvider = FutureProvider((ref) =>
    SharedPreferences.getInstance().then((prefs) => prefs.getString('role')));

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends ConsumerState<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(bottomNavProvider);
    final role = ref.watch(roleStateProvider);
    final List<dynamic> screen = role.when(
        data: (data) => [
              const HomeScreen(),
              const ClassListScreen(),
              const CommunityScreen(),
              const ChatListScreen(),
              if (data == 'Mento') ...[
                const MentorScreen()
              ] else ...[
                const MenteeScreen()
              ]
            ],
        error: ((error, stackTrace) => [
              const HomeScreen(),
              const ClassListScreen(),
              const CommunityScreen(),
              const ChatListScreen(),
              const CircularProgressIndicator()
            ]),
        loading: () => [
              const HomeScreen(),
              const ClassListScreen(),
              const CommunityScreen(),
              const ChatListScreen(),
              const CircularProgressIndicator()
            ]);

    return Scaffold(
      body: SafeArea(child: screen.elementAt(currentPage)),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: Palette.bottomSelectedColor,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.class_rounded,
                  color: Palette.bottomSelectedColor,
                ),
                label: 'Class'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.article_rounded,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.article_rounded,
                  color: Palette.bottomSelectedColor,
                ),
                label: 'Community'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.chat,
                  color: Palette.bottomSelectedColor,
                ),
                label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.chat,
                  color: Palette.bottomSelectedColor,
                ),
                label: 'Match'),
          ],
          currentIndex: currentPage,
          selectedItemColor: Palette.bottomSelectedColor,
          unselectedItemColor: Palette.bottomUnselectedColor,
          onTap: (index) {
            ref.read(bottomNavProvider.notifier).state = index;
          }),
    );
  }
}
