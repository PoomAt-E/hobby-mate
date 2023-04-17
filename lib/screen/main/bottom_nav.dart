import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/chat/chatlist_screen.dart';
import 'package:hobby_mate/screen/community/community_screen.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';
import 'package:hobby_mate/service/auth_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/screen/main/home_screen.dart';
import 'package:hobby_mate/widget/profile_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bottomNavProvider = StateProvider<int>((ref) => 0);

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends ConsumerState<BottomNavigation> {
  final screen = [
    const HomeScreen(),
    const ChatListScreen(),
    const CommunityScreen(),
    const Center(
      child: Text('load..'),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setProfileScreen();
  }

  setProfileScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email')!;

    AuthService().getMember(email).then((value) {
      setState(() {
        screen[3] = ProfileScreen(member: value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(bottomNavProvider);

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
                  Icons.account_circle_rounded,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.account_circle_rounded,
                  color: Palette.bottomSelectedColor,
                ),
                label: 'MyPage'),
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
