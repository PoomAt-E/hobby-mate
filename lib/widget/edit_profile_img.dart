import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EditProfileImage extends StatefulWidget {
  const EditProfileImage({
    Key? key,
    required this.onProfileImagePressed,
    required this.path,
    required this.imageSize,
  }) : super(key: key);

  final Function() onProfileImagePressed;
  final String? path;
  final double imageSize;

  @override
  State<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
          onTap: widget.onProfileImagePressed,
          child: Container(
            width: widget.imageSize,
            height: widget.imageSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: widget.path != null
                      ? FileImage(File(widget.path!))
                      : const AssetImage(
                              'assets/images/default_user_profile.png')
                          as ImageProvider,
                  fit: BoxFit.cover),
            ),
          )),
      Positioned(
        // Positioned : 위치 정렬에 쓰임. 아래는 오른쪽 아래로 부터 0.01만큼 떨어지게 배치하라는 코드
        right: 0,
        bottom: 0,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          width: MediaQuery.of(context).size.height * 0.035,
          height: MediaQuery.of(context).size.height * 0.035,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 20,
          ),
        ),
      )
    ]);
  }
}
