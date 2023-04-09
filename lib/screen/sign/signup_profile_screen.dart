import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/widget/profile_image.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../model/member.dart';
import '../../model/state.dart';
import '../../provider/auth_provider.dart';
import '../../service/image_picker_service.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/title_header.dart';
import 'login_screen.dart';

final authProvider = StateNotifierProvider.autoDispose<AuthState, LoadState>(
    (ref) => AuthState());

final imageProvider = StateProvider<String?>((ref) => null);
final ageProvider = StateProvider((ref) => 20);
final genderProvider = StateProvider((ref) => 'Male');

class SignUpProfileScreen extends ConsumerStatefulWidget {
  final String id;
  final String password;
  final String role;
  const SignUpProfileScreen({
    Key? key,
    required this.id,
    required this.password,
    required this.role,
  }) : super(key: key);

  @override
  SignUpProfileScreenState createState() => SignUpProfileScreenState();
}

class SignUpProfileScreenState extends ConsumerState<SignUpProfileScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime defaultDate = DateTime(
      DateTime.now().year - 19, DateTime.now().month, DateTime.now().day);

  // 회원가입시 프로필 이미지의 path를 DB에 저장하고 프로필 탭에서 DB에 접근하여 사진 로딩하기.
  bool isChoosedPicture = false;

  TextEditingController textEditForName = TextEditingController();
  TextEditingController textEditForNickname = TextEditingController();

  TextEditingController textEditrAddress = TextEditingController();

  @override
  void dispose() {
    ref.invalidate(authProvider);
    ref.invalidate(imageProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = ref.watch(authProvider);
    final imagePath = ref.watch(imageProvider);
    final age = ref.watch(ageProvider);
    final gender = ref.watch(genderProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (isComplete) {
        case LoadState.success:
          ref.invalidate(authProvider);
          toLoginScreen();
          break;

        case LoadState.fail:
          showSnackbar('회원가입에 실패했습니다.');
          break;
        default:
          break;
      }
    });

    // GestureDetector를 최상단으로 두고, requestFocus(FocusNode())를 통해서 키보드를 닫을 수 있음.
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        const TitleHeader(
                          titleContext: 'Profile',
                          subContext: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        ProfileImage(
                          onProfileImagePressed: onProfileImagePressed,
                          path: imagePath,
                          type: 1,
                          imageSize: MediaQuery.of(context).size.height * 0.12,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        CustomInputField(
                          icon: Icons.person_outline,
                          isPassword: false,
                          hintText: 'Name',
                          textEditingController: textEditForName,
                        ),
                        CustomInputField(
                          icon: Icons.person_outline,
                          isPassword: false,
                          hintText: 'Nickname',
                          textEditingController: textEditForNickname,
                        ),
                        const _AgePicker(),
                        CustomInputField(
                          icon: Icons.home_outlined,
                          isPassword: false,
                          hintText: 'Street Address',
                          textEditingController: textEditrAddress,
                        ),
                        GenderWidget()
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    CustomRoundButton(
                        title: 'Profile completed!',
                        onPressed: () =>
                            onPressedSignupButton(imagePath, age, gender)),
                  ]))),
        ));
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  toLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  onProfileImagePressed() async {
    final String? imagePath = await ImagePickerService().pickSingleImage();

    if (imagePath != null) {
      ref.read(imageProvider.notifier).state = imagePath;
    }
  }

  onPressedSignupButton(String? image, int age, String gender) async {
    Map<String, String> member = {
      'name': textEditForName.text,
      'email': widget.id,
      'nickname': textEditForNickname.text,
      'password': widget.password,
      'age': age.toString(),
      'address': textEditrAddress.text,
      'sex': gender,
      // 'introduce': '',
      // 'interest': 0.toString(),
      // 'major': null.toString(),
      // 'user_role': 'ROLE_USER',
    };
    if (image != null) {
      ref.read(authProvider.notifier).signupWithloadImage(image, member);
    }
  }
}

class _AgePicker extends ConsumerWidget {
  const _AgePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(ageProvider);
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.12,
        child: NumberPicker(
            minValue: 15,
            maxValue: 40,
            value: age,
            onChanged: (value) =>
                ref.read(ageProvider.notifier).state = value));
  }
}

class GenderWidget extends ConsumerStatefulWidget {
  const GenderWidget({super.key});

  @override
  _GenderWidgetState createState() => _GenderWidgetState();
}

class _GenderWidgetState extends ConsumerState<GenderWidget> {
  @override
  Widget build(BuildContext context) {
    final gender = ref.watch(genderProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RowButton(
          data: 'Male',
          onGenderChoosed: () => setState(() {
            ref.read(genderProvider.notifier).state = 'Male';
          }),
          state: 'Male' == gender,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        RowButton(
          data: 'Female',
          onGenderChoosed: () => setState(() {
            ref.read(genderProvider.notifier).state = 'Female';
          }),
          state: 'Female' == gender,
        ),
      ],
    );
  }
}

class RowButton extends StatelessWidget {
  final String data;
  final bool state;
  final VoidCallback onGenderChoosed;

  const RowButton({
    Key? key,
    required this.data,
    required this.state,
    required this.onGenderChoosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.055,
        child: ElevatedButton(
          onPressed: onGenderChoosed,
          style: ElevatedButton.styleFrom(
            backgroundColor: state ? Colors.blue[300] : const Color(0xFFEEEEEE),
            // 서브 컬러 - 글자 및 글자 및 애니메이션 색상
            foregroundColor:
                !state ? Colors.grey[600] : const Color(0xFFEEEEEE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
              side: const BorderSide(width: 1, color: Colors.black12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          child: Text(data),
        ),
      ),
    );
  }
}
