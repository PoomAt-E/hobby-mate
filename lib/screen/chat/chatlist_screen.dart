import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/chat_service.dart';
import '../../style/style.dart';
import '../../widget/chat/chat_list.dart';

final counselorListProvider =
    StreamProvider.autoDispose((ref) => ChatService().getChatListData());

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(counselorListProvider);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // const Text('Recent Chats', style: TextStyles.titleTextStyle),
          const SizedBox(height: 20),
          chatList.when(
              data: (item) => item.isEmpty
                  ? const Expanded(
                      child: Center(
                          child: Center(
                              child: Text('No chats yet',
                                  style: TextStyles.shadowTextStyle))))
                  : Expanded(
                      child: ChatList(
                      chats: item,
                    )),
              error: (e, st) =>
                  Expanded(child: Center(child: Text('Error: $e'))),
              loading: () => const Expanded(
                  child: Center(child: CircularProgressIndicator())))
        ]));
  }
}
