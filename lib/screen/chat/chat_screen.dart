import 'package:flutter/material.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';
import 'package:hobby_mate/service/image_picker_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/chat.dart';
import '../../service/chat_service.dart';
import '../../style/style.dart';
import '../../widget/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.chatroomId,
      required this.isNew,
      required this.other});

  final String chatroomId;
  final Member other;
  final bool isNew;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  bool isChoosedPicture = false;
  String newMessage = '';
  bool isSended = false;
  late String userId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('email')!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 키보드 닫기 이벤트
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                '취미에 취하다',
                style: TextStyles.appbarTextStyle,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_sharp,
                    color: Colors.black54),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Color.fromARGB(255, 42, 42, 42),
            extendBodyBehindAppBar: false,
            body: Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                            child: StreamBuilder(
                          stream:
                              ChatService().getChatRoomData(widget.chatroomId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Messages(
                                  messages:
                                      snapshot.data!.messages.reversed.toList(),
                                  userId: userId,
                                  member: widget.other);
                            } else {
                              return const Center(
                                child: Text('sendMessage'),
                              );
                            }
                          },
                        )),
                        sendMesssage()
                      ],
                    ))
              ],
            )));
  }

  Widget sendMesssage() => Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color.fromARGB(18, 0, 0, 0), blurRadius: 10)
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: onSendImagePressed,
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          iconSize: 25,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: onSendMessage,
              icon: const Icon(Icons.send),
              color: Colors.blue,
              iconSize: 25,
            ),
            hintText: "Type your message here",
            hintMaxLines: 1,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            hintStyle: const TextStyle(
              fontSize: 16,
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.black26,
                width: 0.2,
              ),
            ),
          ),
          onChanged: (value) {
            newMessage = value;
          },
        )),
      ]));

  onSendMessage() {
    final Message message = Message(
        content: newMessage,
        sender: userId,
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));

    if (widget.isNew && !isSended) {
      setState(() {
        isSended = true;
      });

      newChatroom();
    } else {
      ChatService().sendMessage(
        widget.chatroomId,
        message,
      );
    }
    _controller.text = '';
    FocusScope.of(context).unfocus();
  }

  newChatroom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('email')!;
    final userName = prefs.getString('name')!;
    final userRole = prefs.getString('role')!;
    final userUrl = prefs.getString('profile_img_url')!;
    final message = Message(
        content: newMessage,
        sender: userId,
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
    final chatroom = ChatRoom(
        chatRoomId: widget.chatroomId,
        user1: ChatMember(
            nickname: widget.other.nickname,
            email: widget.other.email,
            photoUrl: widget.other.profileImageURL,
            role: widget.other.role??'MENTEE'),
        user2: ChatMember(
            nickname: userName, email: userId, role: userRole, photoUrl: userUrl),
        messages: [message]);
    ChatService().newChatRoom(chatroom, message);
  }

  onSendImagePressed() async {
    try {
      final image = await ImagePickerService().pickSingleImage();
      if (image != null) {
        setState(() {
          isChoosedPicture = true;
        });
        final message = Message(
            content: '',
            sender: userId,
            createdAt:
                DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));
        ChatService().sendImage(widget.chatroomId, image, message);
      }
      print(image);
    } catch (e) {
      print(e);
    }
  }

  onProfilePressed(BuildContext context, Member other) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  member: other,
                )));
  }
}
