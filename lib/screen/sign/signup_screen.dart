import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/sign/signup_profile_screen.dart';
import 'package:hobby_mate/util/input_validate.dart';

import '../../style/style.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/title_header.dart';
import 'login_screen.dart';

// 이메일 중복체크
enum EmailDuplicateState { proceeding, success, fail, apifail }
enum ROLES { MENTEE, MENTOR }

final idCheckProvider =
    StateProvider<EmailDuplicateState>((ref) => EmailDuplicateState.proceeding);

final roleProvider = StateProvider<ROLES>((ref) => ROLES.MENTEE);

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
    ref.invalidate(idCheckProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idCheckState = ref.watch(idCheckProvider);
    final role = ref.watch(roleProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (idCheckState) {
        case EmailDuplicateState.success:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpProfileScreen(
                        id: textEditingControllerForId.text,
                        password: textEditingControllerForPw.text,
                        role: role,
                      )));
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
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(children: [
              Expanded(
                  child: Center(
                      child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    const TitleHeader(titleContext: 'Sign Up', subContext: ''),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    CustomInputField(
                      icon: Icons.email_outlined,
                      isPassword: false,
                      title: 'E-Mail',
                      textEditingController: textEditingControllerForId,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015),
                    CustomInputField(
                      icon: Icons.lock_outline,
                      isPassword: true,
                      title: 'Password',
                      textEditingController: textEditingControllerForPw,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text('비밀번호는 소문자, 대문자, 특수문자 포함 8자리 이상입니다.',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400)),),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015),
                    CustomInputField(
                      icon: Icons.lock_outline,
                      isPassword: true,
                      title: 'Check your Password',
                      textEditingController: textEditingControllerForCheckPw,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015),
                    const RoleWidget(),
                    const _PopLoginPage(),
                  ],
                ),
              ))),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                child: CustomRoundButton(
                    title: 'Create Account', onPressed: onPressedSignupButton),
              )
            ])));
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  onPressedSignupButton() {
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpProfileScreen(
                  id: textEditingControllerForId.text,
                  password: textEditingControllerForPw.text,
                  role: ref.read(roleProvider), // 임시
                )));

    //   try {
    //     bool result = await AuthService().emailCheck(email, 'ROLE_USER');
    //     if (result) {
    //       ref.read(idCheckProvider.notifier).state = EmailDuplicateState.success;
    //     } else {
    //       ref.read(idCheckProvider.notifier).state = EmailDuplicateState.fail;
    //     }
    //   } catch (e) {
    //     ref.read(idCheckProvider.notifier).state = EmailDuplicateState.apifail;
    //   }
  }
}

class RoleWidget extends ConsumerStatefulWidget {
  const RoleWidget({super.key});

  @override
  RoleWidgetState createState() => RoleWidgetState();
}

class RoleWidgetState extends ConsumerState<RoleWidget> {
  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RowButton(
          data: '멘토',
          onGenderChoosed: () => setState(() {
            ref.read(roleProvider.notifier).state = ROLES.MENTOR;
          }),
          state: role == ROLES.MENTOR,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        RowButton(
            data: '멘티',
            onGenderChoosed: () => setState(() {
                  ref.read(roleProvider.notifier).state = ROLES.MENTEE;
                }),
            state: role == ROLES.MENTEE),
      ],
    );
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
