import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/sign/login_screen.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';
import 'main/bottom_nav.dart';

// final loginStateProvider =
//     FutureProvider.autoDispose((ref) => AuthService().isLogin());
final loginStateProvider = FutureProvider.autoDispose((ref) async {
  final sharedPref = await SharedPreferences.getInstance();
  final isLogin = sharedPref.getString('email');
  return isLogin == null ? false : true;
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(loginStateProvider);

    void toMainScreen() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
          (route) => false);
    }

    void toLoginScreen() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }

    Future.delayed(const Duration(milliseconds: 1000), () async {
      isLogin.when(
        data: (value) {
          if (value == true) {
            toMainScreen(); // 메인화면으로 이동
          } else if (value == false) {
            toLoginScreen(); // 로그인화면으로 이동
          }
        },
        loading: () {},
        error: (error, stackTrace) {},
      );
    });

    return Container(
      color: Colors.white,
      child: const Center(
          child: Text('취미에\n취하다', style: TextStyles.splashScreenTextStyle)),
    );
  }
}
