import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/sign/signup_screen.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/widget/edit_profile_img.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../model/state.dart';
import '../../provider/auth_provider.dart';
import '../../service/image_picker_service.dart';
import '../../widget/custom_textfield.dart';
import 'login_screen.dart';

final authProvider = StateNotifierProvider.autoDispose<AuthState, LoadState>(
    (ref) => AuthState());

final imageProvider = StateProvider<String?>((ref) => null);
final ageProvider = StateProvider((ref) => 20);
final genderProvider = StateProvider((ref) => 'Male');
final phoneProvider = StateProvider((ref) => '');

class SignUpProfileScreen extends ConsumerStatefulWidget {
  final String id;
  final String password;
  final ROLES role;

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
  TextEditingController textEditForAddress = TextEditingController();
  TextEditingController textEditForAddressDetail = TextEditingController();
  TextEditingController textEditForPhone = TextEditingController();
  TextEditingController textEditForIntroduce = TextEditingController();
  TextEditingController textEditForMajor = TextEditingController();

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
    final interest = ref.watch(interestProvider);

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

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 23,
                    color: Colors.black),
                title: const Text(
                  'Profile',
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leadingWidth: 50,
                actions: [
                  IconButton(
                    iconSize: 50,
                    icon: const Icon(
                      Icons.check_circle_outline_sharp,
                      size: 25,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      onPressedSignupButton(imagePath, age, gender, interest);
                    },
                  )
                ],
                leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 22,
                      color: Colors.blue,
                    ),
                    onPressed: () => Navigator.pop(context))),
            body: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: EditProfileImage(
                              onProfileImagePressed: onProfileImagePressed,
                              path: imagePath,
                              imageSize:
                                  MediaQuery.of(context).size.height * 0.12,
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        CustomInputField(
                          icon: Icons.person_outline,
                          isPassword: false,
                          title: 'name',
                          textEditingController: textEditForName,
                        ),
                        CustomInputField(
                          icon: Icons.person_outline,
                          isPassword: false,
                          title: 'nickname',
                          textEditingController: textEditForNickname,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        const Text('age',
                            style: TextStyles.editProfileTitleTextStyle),
                        const _AgePicker(),
                        CustomInputField(
                          icon: Icons.home_outlined,
                          isPassword: false,
                          title: 'Street Address',
                          textEditingController: textEditForAddress,
                        ),
                        CustomInputField(
                          icon: Icons.home_outlined,
                          isPassword: false,
                          title: 'Address Detail',
                          textEditingController: textEditForAddressDetail,
                        ),
                        CustomInputField(
                          icon: Icons.phone_outlined,
                          isPassword: false,
                          title: 'phone',
                          hintText: 'input without \'-\'',
                          textEditingController: textEditForPhone,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.015),
                          child: const Text('gender',
                              style: TextStyles.editProfileTitleTextStyle),
                        ),
                        const GenderWidget(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        CustomInputField(
                          icon: Icons.book_outlined,
                          isPassword: false,
                          title: widget.role == '' ? 'interest' : 'major',
                          textEditingController: textEditForMajor,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        CustomInputField(
                          icon: Icons.phone_outlined,
                          isPassword: false,
                          title: 'introduce',
                          textEditingController: textEditForIntroduce,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ]),
                ))));
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
    final File? image = await ImagePickerService().pickSingleImage();

    if (image != null) {
      ref.read(imageProvider.notifier).state = image.path;
    }
  }

  onPressedSignupButton(
      String? image, int age, String gender, String interest) async {

    Map<String, dynamic> member = {
      'name': textEditForName.text,
      'email': widget.id,
      'nickname': textEditForNickname.text,
      'password': widget.password,
      'age': age,
      'address': textEditForAddress.text,
      'addressDetail': textEditForAddressDetail.text,
      'sex': gender,
      'introduce': textEditForIntroduce.text,
      'role': widget.role == ROLES.MENTEE ? 'MENTEE' : 'MENTOR',
      'phone': textEditForPhone.text,
      'interests': [textEditForMajor.text],
      'majors': [textEditForMajor.text]
    };
    if (widget.role == ROLES.MENTOR) {
      member['major'] = interest;
    } else {
      member['interest'] = interest;
    }
    ref.read(authProvider.notifier).signUp(member);
    // if (image != null) {
    //   ref.read(authProvider.notifier).signupWithloadImage(image, member);
    // }
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
        width: MediaQuery.of(context).size.width,
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
        child: TextButton(
          onPressed: onGenderChoosed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                state ? Colors.blue[300] : Palette.boxContainerColor,
            // 서브 컬러 - 글자 및 글자 및 애니메이션 색상
            foregroundColor: !state ? Colors.black87 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
            ),
            textStyle: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
          ),
          child: Text(data),
        ),
      ),
    );
  }
}

final interestProvider = StateProvider((ref) => '');

class InterestPicker extends ConsumerWidget {
  const InterestPicker({super.key, required this.list});

  final List<String> list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interest = ref.watch(interestProvider);

    Widget sheetWidget() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: CupertinoPicker.builder(
            childCount: list.length,
            itemExtent: 75,
            onSelectedItemChanged: (value) {
              ref.read(interestProvider.notifier).state = list[value];
            },
            itemBuilder: (context, index) {
              return Container(
                  alignment: Alignment.center, child: Text(list[index]));
            }));
    return InkWell(
        onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => sheetWidget(),
            ),
        child: Container(
            alignment: Alignment.center,
            height: 55,
            decoration: BoxDecoration(
              color: Palette.boxContainerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width - 64,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(width: 30),
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          interest,
                          style: const TextStyle(fontSize: 20),
                        ),
                      )),
                  const Icon(Icons.arrow_drop_down,
                      size: 30, color: Colors.black54),
                ])));
  }
}
