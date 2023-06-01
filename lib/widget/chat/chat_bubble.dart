import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';

import '../../model/chat.dart';
import '../../style/style.dart';
import '../profile_button.dart';
import 'chat_time_format.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.member, {Key? key})
      : super(key: key);

  final Message message;
  final Member member;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe) ...{
            if (message.content.contains('image@')) ...{
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(dataTimeFormat(message.createdAt),
                            style: TextStyles.shadowTextStyle),
                        SizedBox(
                            width: 220,
                            height: 190,
                            child: BubbleNormalImage(
                              id: '1',
                              color: Colors.amber,
                              image: Image.network(
                                  message.content.split('@')[1],
                                  width: 250,
                                  height: 250),
                            ))
                      ])),
            } else ...{
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(dataTimeFormat(message.createdAt),
                            style: TextStyles.shadowTextStyle),
                        BubbleSpecialOne(
                            text: message.content,
                            isSender: true,
                            color: Colors.blue,
                            textStyle: TextStyles.blueBottonTextStyle),
                      ]))
            },
          },
          if (!isMe) ...{
            if (message.content.contains('image@')) ...{
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileButton(
                            nickname: member.name,
                            path: member.profileImageURL,
                            onProfilePressed: onProfilePressed),
                        Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      width: 220,
                                      height: 190,
                                      child: BubbleNormalImage(
                                        id: '1',
                                        color: Colors.amber,
                                        image: Image.network(
                                            message.content.split('@')[1],
                                            width: 250,
                                            height: 250),
                                      )),
                                  Text(dataTimeFormat(message.createdAt),
                                      style: TextStyles.shadowTextStyle),
                                ]))
                      ])),
            } else ...{
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileButton(
                            nickname: member.name,
                            path: member.profileImageURL,
                            onProfilePressed: onProfilePressed),
                        Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  BubbleSpecialOne(
                                    text: message.content,
                                    isSender: false,
                                    color: Colors.amber.withOpacity(0.3),
                                    textStyle:
                                        TextStyles.chatNotMeBubbleTextStyle,
                                  ),
                                  Text(dataTimeFormat(message.createdAt),
                                      style: TextStyles.shadowTextStyle),
                                ]))
                      ]))
            },
          }
        ]);
  }

  onProfilePressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  member: member,
                )));
  }
}
