import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/sign/signup_profile_screen.dart';
import 'package:hobby_mate/util/input_validate.dart';

import '../../config/style.dart';
import '../../service/auth_service.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/title_header.dart';
import 'login_screen.dart';

// 이메일 중복체크
enum EmailDuplicateState { proceeding, success, fail, apifail }

final idCheckProvider =
    StateProvider<EmailDuplicateState>((ref) => EmailDuplicateState.proceeding);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<SignupScreen> {
  TextEditingController textEditingControllerForId = TextEditingController();
  TextEditingController textEditingControllerForPw = TextEditingController();
  TextEditingController textEditingControllerForCheckPw =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(idCheckProvider.notifier).state =
        EmailDuplicateState.proceeding; // 초기화
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ref.invalidate(idCheckProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idCheckState = ref.watch(idCheckProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (idCheckState) {
        case EmailDuplicateState.success:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpProfileScreen(
                      id: textEditingControllerForId.text,
                      password: textEditingControllerForPw.text)));
          break;
        case EmailDuplicateState.fail:
          showSnackbar('중복된 이메일이 있습니다');
          break;
        case EmailDuplicateState.apifail:
          showSnackbar('회원가입에 실패했습니다');
          break;
        default:
      }
      ref.read(idCheckProvider.notifier).state = EmailDuplicateState.proceeding;
    });

    // GestureDetector를 최상단으로 두고, requestFocus(FocusNode())를 통해서 키보드를 닫을 수 있음.
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                      Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2),
                          const TitleHeader(
                            titleContext: 'Sign Up',
                            subContext:
                                'Experience a service that helps prevent and treat various addictions with Diviction.',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          CustomInputField(
                            icon: Icons.email_outlined,
                            isPassword: false,
                            hintText: 'E-Mail',
                            textEditingController: textEditingControllerForId,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
                          CustomInputField(
                            icon: Icons.lock_outline,
                            isPassword: true,
                            hintText: 'Password',
                            textEditingController: textEditingControllerForPw,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
                          CustomInputField(
                            icon: Icons.lock_outline,
                            isPassword: true,
                            hintText: 'Check your Password',
                            textEditingController:
                                textEditingControllerForCheckPw,
                          ),
                          const _PopLoginPage(),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      CustomRoundButton(
                          title: 'Create Account',
                          onPressed: onPressedSignupButton),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10),
                    ])))));
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  onPressedSignupButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpProfileScreen(
                id: textEditingControllerForId.text,
                password: textEditingControllerForPw.text)));

    // 입력 체크
    if (textEditingControllerForId.text == '' ||
        textEditingControllerForPw.text == '' ||
        textEditingControllerForCheckPw.text == '') {
      // 입력 체크
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이메일과 비밀번호를 모두 입력해주세요')));
    } else if (textEditingControllerForPw.text !=
        textEditingControllerForCheckPw.text) {
      // 비밀번호 체크
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('비밀번호를 체크해주세요')));
    } else if (!InputValidate(textEditingControllerForId.text)
        .isValidEmailFormat()) {
      // 이메일 형식 체크
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이메일 형식으로 입력해주세요')));
    } else {
      // 이메일 중복 체크
      checkEmail(textEditingControllerForId.text);
    }
  }

  void checkEmail(String email) async {
    try {
      bool result = await AuthService().emailCheck(email, 'ROLE_USER');
      if (result) {
        ref.read(idCheckProvider.notifier).state = EmailDuplicateState.success;
      } else {
        ref.read(idCheckProvider.notifier).state = EmailDuplicateState.fail;
      }
    } catch (e) {
      ref.read(idCheckProvider.notifier).state = EmailDuplicateState.apifail;
    }
  }
}

class _PopLoginPage extends StatelessWidget {
  const _PopLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyles.underlineTextStyle,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              const Text(
                'Log in',
                style: TextStyle(color: Color(0xFF3E3E3E)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
