import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String chatRoomId;
  ChatMember user1;
  ChatMember user2;
  List<Message> messages;

  ChatRoom(
      {required this.chatRoomId,
      required this.user1,
      required this.user2,
      required this.messages});

  factory ChatRoom.fromJson(Map<dynamic, dynamic> json) {
    return ChatRoom(
        chatRoomId: json['chatRoomId'],
        user1: json['user1'].map((user1) => ChatMember.fromJson(user1)),
        user2: json['user2'].map((user2) => ChatMember.fromJson(user2)),
        messages: json['messages']
            .map((message) => Message.fromJson(message))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
      'messages': messages.map((message) => message.toJson()).toList()
    };
  }

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final List<Message> message = [];
    final messageSnapshot = List<Map>.from(snapshot['messages'] as List);
    for (var e in messageSnapshot) {
      message.add(Message.fromJson(e as Map<String, dynamic>));
    }
    return ChatRoom(
        chatRoomId: snapshot['chatRoomId'],
        user1: ChatMember.fromJson(snapshot['user1'] as Map<String, dynamic>),
        // .map((user1 a) => ChatMember.fromJson(user1)),
        user2: ChatMember.fromJson(snapshot['user2'] as Map<String, dynamic>),
        messages: message);
    // .map((message) => Message.fromJson(message))
    // .toList());
  }
}

class ChatMember {
  String name;
  String email;
  String? photoUrl;
  String role;

  ChatMember(
      {required this.name,
      required this.email,
      this.photoUrl,
      required this.role});

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
        name: json['name'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        role: json['role']);
  }
  toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
    };
  }
}

class Message {
  String content;
  String sender;
  String createdAt;

  Message(
      {required this.content, required this.sender, required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        content: json['content'],
        sender: json['sender'],
        createdAt: json['createdAt']);
  }
  toJson() {
    return {
      'content': content,
      'sender': sender,
      'createdAt': createdAt,
    };
  }
}

class MyChat {
  String chatRoomId;
  String otherEmail;
  String otherName;
  String otherPhotoUrl;
  String lastMessage;
  String lastTime;

  MyChat(
      {required this.chatRoomId,
      required this.otherEmail,
      required this.otherName,
      required this.otherPhotoUrl,
      required this.lastMessage,
      required this.lastTime});

  factory MyChat.fromJson(Map<dynamic, dynamic> json) {
    return MyChat(
        chatRoomId: json['chatRoomId'],
        otherEmail: json['otherEmail'],
        otherName: json['otherName'],
        otherPhotoUrl: json['otherPhotoUrl'],
        lastMessage: json['lastMessage'],
        lastTime: json['lastTime']);
  }

  get lastMessageTime => null;
  toJson() {
    return {
      'chatRoomId': chatRoomId,
      'otherEmail': otherEmail,
      'otherName': otherName,
      'otherPhotoUrl': otherPhotoUrl,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
    };
  }
}
