import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/chat.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/chat/chat_screen.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';
import 'package:hobby_mate/service/chat_service.dart';
import 'package:hobby_mate/widget/appbar.dart';

import '../service/member_service.dart';
import '../style/style.dart';
import '../widget/profile_image.dart';

final chatListProvider =
    FutureProvider<List<MyChat>>((ref) => ChatService().getChatList());

final memberProvider = FutureProvider<List<Member>>((ref) async {
  final chatlist = await ref.watch(chatListProvider.future);
  final List<Member> recommendMemberList =
      await MemberService().getRecommendMember();

  final chatMemberNamelist = chatlist.map((e) => e.otherName);

  if (chatlist.isNotEmpty) {
    return recommendMemberList
        .where((element) => chatMemberNamelist.contains(element.name))
        .toList();
  } else {
    return [];
  }
});

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  @override
  Widget build(BuildContext context) {
    final memberlist = ref.watch(memberProvider);

    return Scaffold(
      appBar: const MainAppbar(),
      body: Placeholder(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('나와 취미가 맞는 사람들'),
              memberlist.when(
                  data: (item) => item.isEmpty
                      ? const Expanded(
                          child: Center(
                              child: Center(
                                  child: Text('No members yet',
                                      style: TextStyles.shadowTextStyle))))
                      : Expanded(
                          child: MatchList(
                          members: item,
                        )),
                  error: (e, st) =>
                      Expanded(child: Center(child: Text('Error: $e'))),
                  loading: () => const Expanded(
                      child: Center(child: CircularProgressIndicator()))),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchList extends StatefulWidget {
  const MatchList({super.key, required this.members});

  final List<Member> members;

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.members.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => onProfileTap(widget.members[index]),
                child: Row(
                  children: [
                    ProfileImage(
                      onProfileImagePressed: () =>
                          onProfileTap(widget.members[index]),
                      path: widget.members.elementAt(index).profileImgUrl,
                      imageSize: MediaQuery.of(context).size.width * 0.12,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text.rich(
                          TextSpan(
                              text: '${widget.members[index].name}\n',
                              style: TextStyles.chatHeading,
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        widget.members.elementAt(index).address,
                                    style: TextStyles.chatbodyText),
                              ]),
                          textAlign: TextAlign.start,
                        )),
                  ],
                ),
              ),
              InkWell(
                  onTap: () => onButtonClick(widget.members[index]),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.24,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 42, 42, 42),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child:
                          Text('채팅해보기', style: TextStyles.blueBottonTextStyle),
                    ),
                  ))
            ],
          );
        });
  }

  void onProfileTap(Member member) {
    Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  member: member,
                )) // 리버팟 적용된 HomeScreen 만들기
        );
  }

  void onButtonClick(Member member) async {
    final chatroomId = await ChatService().makeChatroomId(member.email);

    toChatScreen(chatroomId, member);
  }

  void toChatScreen(String chatroomId, Member member) {
    Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreen(
                  chatroomId: chatroomId,
                  isNew: true,
                  other: member,
                )) // 리버팟 적용된 HomeScreen 만들기
        );
  }
}
