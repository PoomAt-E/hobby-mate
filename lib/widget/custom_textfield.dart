import 'package:flutter/material.dart';

import '../style/style.dart';

class CustomInputField extends StatelessWidget {
  final bool isPassword;
  final String hintText;
  final IconData icon;
  final TextEditingController textEditingController;

  const CustomInputField({
    Key? key,
    required this.isPassword,
    required this.hintText,
    required this.icon,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 7,
      ),
      Text(hintText, style: TextStyles.editProfileTitleTextStyle),
      const SizedBox(
        height: 5,
      ),
      Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
        height: 55,
        decoration: BoxDecoration(
          color: Palette.boxContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: TextField(
            obscureText: isPassword,
            controller: textEditingController,
            cursorColor: Colors.grey,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      )
    ]);
  }
}
