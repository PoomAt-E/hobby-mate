import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat.dart';
import 'firebase_storage_service.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() {
    return _chatService;
  }
  ChatService._internal() {
    getUserEmail();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MyChat> userChatlist = [];
  late SharedPreferences prefs;

  String userEmail = '';

  Future<String> makeChatroomId(String otherEmail) async {
    if (userEmail == '') await getUserEmail();

    final List<String> emails = [userEmail, otherEmail];
    emails.sort();
    return emails.join('&').replaceAll('.', '');
  }

  Future<String> getUserEmail() async {
    prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email')!.replaceAll('.', '');
    return userEmail;
  }

  Future<List<MyChat>> getChatList() async {
    try {
      if (userEmail == '') {
        await getUserEmail();
      }
      ;
      final snapshot =
          await _firestore.collection('users').doc(userEmail).get();
      if (snapshot.exists) {
        final List<MyChat> chats = [];
        (snapshot.data() as Map)
            .entries
            .map((e) => chats.add(MyChat.fromJson(e.value)))
            .toList();

        return chats;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Stream<List<MyChat>> getChatListData() async* {
    try {
      if (userEmail == '') {
        await getUserEmail();
      }
      final data = _firestore
          .collection('users')
          .doc(userEmail)
          .snapshots()
          .map((event) {
        final List<MyChat> chats = [];
        if (event.data() == null) return chats;
        (event.data() as Map)
            .entries
            .map((e) => chats.add(MyChat.fromJson(e.value)))
            .toList();

        return chats;
      });
      yield* data;
    } catch (e) {
      print(e);
      if (e is FirebaseException && e.code == 'path.isNotEmpty') yield [];
    }
  }

  Stream<ChatRoom> getChatRoomData(String chatroomId) {
    try {
      final stream = _firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .snapshots()
          .map((event) => ChatRoom.fromDocumentSnapshot(event));

      return stream;
    } catch (e) {
      throw e;
    }
  }

  void sendMessage(String chatRoomId, Message message) async {
    try {
      final snapshot =
          await _firestore.collection('chatrooms').doc(chatRoomId).get();
      if (snapshot.exists) {
        final roomData = ChatRoom.fromDocumentSnapshot(snapshot);
        final messages = roomData.messages;
        messages.add(message);
        _firestore
            .collection('chatrooms')
            .doc(chatRoomId)
            .update({'messages': messages.map((e) => e.toJson()).toList()});
      }

      savaLastMessage(userEmail, chatRoomId, message);
      savaLastMessage(chatRoomId.split('&')[0], chatRoomId, message);
    } catch (e) {
      print(e);
    }
  }

  savaLastMessage(String id, String chatRoomId, Message message) async {
    try {
      final snapshot = await _firestore.collection('users').doc(id).get();
      if (snapshot.exists) {
        final chat = MyChat.fromJson(snapshot.data()![chatRoomId]);
        if (message.content.contains('image@')) {
          chat.lastMessage = '사진';
        } else {
          chat.lastMessage = message.content;
        }
        chat.lastTime = message.createdAt;
        _firestore
            .collection('users')
            .doc(id)
            .update({chatRoomId: chat.toJson()});
      } else {
        final chat = MyChat(
            chatRoomId: chatRoomId,
            otherEmail: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherName: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherPhotoUrl: '1',
            lastMessage: message.content,
            lastTime: message.createdAt);
        _firestore.collection('users').doc(id).set({chatRoomId: chat.toJson()});
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        final chat = MyChat(
            chatRoomId: chatRoomId,
            otherEmail: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherName: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherPhotoUrl: '1',
            lastMessage: message.content,
            lastTime: message.createdAt);
        _firestore.collection('users').doc(id).set({chatRoomId: chat.toJson()});
      } else {
        print(e);
      }
    }
  }

  Future sendImage(String chatRoomId, File file, Message message) async {
    final url = await FirebaseStorageService()
        .uploadImage('$chatRoomId/${file.path}', file);
    message.content = 'image@$url';
    sendMessage(chatRoomId, message);
  }

  Future newChatRoom(ChatRoom chatroom, Message message) async {
    // 멘토
    await saveUserChatlist(
        chatroom.user1.email.replaceAll('.', ''),
        MyChat(
            chatRoomId: chatroom.chatRoomId,
            otherEmail: chatroom.user2.email,
            otherName: chatroom.user2.nickname,
            otherPhotoUrl: chatroom.user2.photoUrl!,
            lastMessage: message.content,
            lastTime: message.createdAt));
    // 본인
    await saveUserChatlist(
        chatroom.user2.email.replaceAll('.', ''),
        MyChat(
            chatRoomId: chatroom.chatRoomId,
            otherEmail: chatroom.user1.email,
            otherName: chatroom.user1.nickname,
            otherPhotoUrl: chatroom.user1.photoUrl!,
            lastMessage: message.content,
            lastTime: message.createdAt));

    _firestore
        .collection('chatrooms')
        .doc(chatroom.chatRoomId)
        .set(chatroom.toJson());
  }

  Future saveUserChatlist(String id, MyChat chat) async {
    try {
      final snapshot = await _firestore.collection('users').doc(id).get();
      if (snapshot.exists && snapshot.data() != null) {
        _firestore
            .collection('users')
            .doc(id)
            .update({chat.chatRoomId: chat.toJson()});
      } else {
        _firestore
            .collection('users')
            .doc(id)
            .set({chat.chatRoomId: chat.toJson()});
      }
    } catch (e) {
      if (e is FirebaseException && e.code == "not-found") {
        _firestore
            .collection('users')
            .doc(id)
            .set({chat.chatRoomId: chat.toJson()});
      } else {
        print(e);
      }
    }

    // List<MyChat> rooms = [];
    // if (snapshot.exists) {
    //   final data = snapshot.data()!['chatlist'];
    //   for (var e in data) {
    //     rooms.add(MyChat.fromJson(e));
    //   }
    //   if (rooms.isEmpty) {
    //     rooms = [chat];
    //   } else {
    //     rooms.add(chat);
    //   }
    // }

    // _firestore
    //     .collection('users')
    //     .doc(id)
    //     .set({'chatlist': rooms.map((e) => e.toJson())});
  }
}
