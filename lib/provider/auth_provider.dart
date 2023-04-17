import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/state.dart';
import '../service/auth_service.dart';

class AuthState extends StateNotifier<LoadState> {
  AuthState() : super(LoadState.proceeding);

  @override
  set state(LoadState value) {
    super.state = value;
  }

  Future signIn(String email, String password) async {
    // 로그인
    try {
      var result = await AuthService().signIn(email, password); // 로그인 요청
      if (result) {
        state = LoadState.success; // 로그인 성공
        saveData(email); // 로그인 성공시 기기에 모든 유저 정보 저장
      } else {
        state = LoadState.fail; // 로그인 실패
      }
    } catch (e) {
      state = LoadState.fail; // 로그인 실패
    }
  }

  Future signupWithloadImage(String path, Map<String, String> member) async {
    try {
      var result =
          await AuthService().signupWithloadImage(path: path, member: member);
      if (result) {
        state = LoadState.success;
      } else {
        state = LoadState.fail;
      }
    } catch (e) {
      state = LoadState.fail;
    }
  }

  saveData(String email) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == null || prefs.getString('email') != email) {
      AuthService().getMember(email);
    }
  }
}
