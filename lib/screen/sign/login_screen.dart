import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/sign/signup_screen.dart';

import '../../style/style.dart';
import '../../model/state.dart';
import '../../provider/auth_provider.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/title_header.dart';
import '../main/bottom_nav.dart';

final authProvider = StateNotifierProvider.autoDispose<AuthState, LoadState>(
    (ref) => AuthState());

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController textEditingControllerForId = TextEditingController();
  TextEditingController textEditingControllerForPw = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    ref.invalidate(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(authProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  위젯이 모두 빌드 된 후 실행 (빌드중 리빌드 오류 방지)
      switch (isLogin) {
        case LoadState.success:
          ref.invalidate(authProvider);
          toMain();
          break;
        case LoadState.fail:
          showSnackbar('로그인에 실패했습니다.');
          ref.invalidate(authProvider);
          break;
        default:
      }
    });

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const TitleHeader(
                                    titleContext: 'Log In',
                                    subContext: '',
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  CustomInputField(
                                    icon: Icons.email_outlined,
                                    isPassword: false,
                                    title: 'E-Mail',
                                    textEditingController:
                                        textEditingControllerForId,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.015),
                                  CustomInputField(
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    title: 'Password',
                                    textEditingController:
                                        textEditingControllerForPw,
                                  ),
                                  const _PushSignupPage(),
                                ])))),
                Container(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                    child: Column(children: [
                      CustomRoundButton(
                        title: 'Log In',
                        onPressed: onPressedLoginButton,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget Password?",
                            style: TextStyles.underlineTextStyle,
                          ),
                        ),
                      )
                    ]))
              ],
            )));
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  toMain() {
    // 로그인 성공시 메인페이지로
    Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                const BottomNavigation()) // 리버팟 적용된 HomeScreen 만들기
        );
  }

  onPressedLoginButton() async {
    if (textEditingControllerForId.text == '' ||
        textEditingControllerForPw.text == '') {
      showSnackbar('아이디와 비밀번호를 모두 입력해주세요.');
    } else {
      ref.read(authProvider.notifier).signIn(
          textEditingControllerForId.text, textEditingControllerForPw.text);
    }
  }
}

class _PushSignupPage extends StatelessWidget {
  const _PushSignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const SignupScreen(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Don't have an account?",
                  style: TextStyles.underlineTextStyle),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              const Text(
                'Sign up',
                style: TextStyle(color: Color(0xFF3E3E3E)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomRoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomRoundButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(219, 139, 139, 139),
              padding: const EdgeInsets.symmetric(vertical: 20), // 버튼 위아래 패딩 조절
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(49), // 모서리 둥글게
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
