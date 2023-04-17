import 'package:flutter/material.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/chat.dart';
import '../../screen/chat/chat_screen.dart';
import '../../service/auth_service.dart';
import '../../style/style.dart';
import '../profile_image.dart';
import 'chat_time_format.dart';

class ChatList extends StatelessWidget {
  const ChatList({this.chats, super.key});

  final List<MyChat>? chats;

  @override
  Widget build(BuildContext context) {
    onProfilePressed(BuildContext context, String email) async {
      final member = await AuthService().getMember(email);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    member: member,
                  )));
    }

    void toChatroom(String chatroomId, Member member) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatroomId: chatroomId,
                    isNew: false,
                    other: member,
                  )));
    }

    onButtonPressed(String email) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('email')!;
      String chatroomId = ('$email&$userEmail').replaceAll('.', '');

      final counselor = await AuthService().getMember(email);

      toChatroom(chatroomId, counselor);
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: chats!.length,
        padding: const EdgeInsets.only(bottom: 40),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () => onButtonPressed(
                    chats!.elementAt(index).otherEmail,
                  ),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 20),
                  child: Stack(children: [
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(children: [
                            GestureDetector(
                              onTap: () => onProfilePressed(
                                  context, chats!.elementAt(index).otherEmail),
                              child: ProfileImage(
                                onProfileImagePressed: () => onProfilePressed(
                                    context,
                                    chats!.elementAt(index).otherEmail),
                                path: chats![index].otherPhotoUrl,
                                imageSize: 50,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(chats![index].otherName,
                                    style: TextStyles.chatHeading),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(chats![index].lastMessage,
                                    style: TextStyles.chatbodyText),
                              ],
                            ),
                          ]),
                          // Text(dataTimeFormat(chats![index].lastTime),
                          //     style: TextStyles.chatbodyText),
                        ]),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(dataTimeFormat(chats![index].lastTime),
                          style: TextStyles.chatTimeText),
                    )
                  ])));
        });
  }
}
