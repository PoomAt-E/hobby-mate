import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/screen/class/class_vod_player_screen.dart';
import 'package:hobby_mate/service/auth_service.dart';
import 'package:hobby_mate/service/streaming_service.dart';
import 'package:hobby_mate/widget/profile_image.dart';

import '../../model/member.dart';
import '../../model/vod.dart';
import '../../service/chat_service.dart';
import '../../style/style.dart';
import '../chat/chat_screen.dart';

class ClassDetailScreen extends ConsumerStatefulWidget {
  const ClassDetailScreen({super.key, required this.vodGroupId});

  final String vodGroupId;

  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends ConsumerState<ClassDetailScreen> {
  late FutureProvider<VodGroup> vodProvider;

  @override
  void initState() {
    vodProvider = FutureProvider<VodGroup>(
        (ref) => StreamingService().getVodDetail(widget.vodGroupId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vod = ref.watch(vodProvider);
    return vod.when(
        data: (vod) {
          return Scaffold(
              body: CustomScrollView(slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      true ? Icons.favorite_rounded : Icons.favorite_border,
                      color: Colors.red,
                    ))
              ],
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(vod.vodGroupName,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12))),
                background: Image(
                  image: NetworkImage(vod.thumbnailURL),
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.8),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
            ),
            SliverFillRemaining(
                child: Flex(direction: Axis.vertical, children: [
              Expanded(
                  child: SingleChildScrollView(
                child: vod.vodList == null || vod.vodList!.isEmpty
                    ? const Center(child: Text('No VODs'))
                    : Column(
                        children: vod.vodList!.map((e) {
                        final index = vod.vodList!.indexOf(e);
                        return ExpansionTile(
                            title: Text(
                              e.title,
                            ),
                            collapsedTextColor:
                                index == 0 ? Colors.black : Colors.black45,
                            trailing: index == 0
                                ? const Icon(
                                    Icons.arrow_drop_down,
                                    size: 20,
                                    color: Colors.black87,
                                  )
                                : const Icon(
                                    Icons.lock,
                                    size: 20,
                                    color: Colors.black45,
                                  ),
                            children: [
                              ClassWeekBox(
                                  vod: e,
                                  onClick: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                                  vod: e,
                                                  vodGroup: vod,
                                                )));
                                    // 리버팟 적용된 HomeScreen 만들기
                                  })
                            ]);
                      }).toList()),
              )),
              Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            ProfileImage(
                                onProfileImagePressed: () {},
                                path: null,
                                imageSize: 50),
                            const SizedBox(width: 10),
                            Text(
                              '강사: ${vod.ownerId?? '정승환'}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () => onButtonClick("test111@gmail.com"),
                            child: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 42, 42, 42),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.chat_bubble,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )))
                      ])),
              InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('결제하기'),
                          content: Text(
                              '\'${vod.vodGroupName}\' 구매하시겠습니까?\n금액: 45,000원'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('취소')),
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('확인')),
                          ],
                        )),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.teal,
                  alignment: Alignment.center,
                  child: const Text(
                    '\'45,000원\' 구매하기',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 4개의 강의',
                        style: TextStyle(color: Colors.black54, fontSize: 12)),
                    Text('총 4시간 30분',
                        style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              Container()
            ]))
          ]));
        },
        error: (error, st) {
          return const Center(child: Text('수업을 불러오는데 실패했습니다.'));
        },
        loading: () => CircularProgressIndicator());
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

  void onButtonClick(String email1) async {
    // 나중에 Member로 바꿔야함
    final chatroomId = await ChatService().makeChatroomId(email1);
    final member = await AuthService().getMemberInfo(email1);
    toChatScreen(chatroomId, member);
  }
}

class ClassWeekBox extends StatelessWidget {
  const ClassWeekBox({super.key, required this.vod, required this.onClick});

  final Vod vod;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.1;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              InkWell(
                  onTap: () => onClick(),
                  child: Stack(
                    children: [
                      Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(vod.thumbnailURL))),
                      ),
                      SizedBox(
                        height: size,
                        width: size,
                        child: Center(
                            child: Icon(
                          Icons.play_circle,
                          color: Colors.white.withOpacity(0.5),
                          size: 40,
                        )),
                      )
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width - size - 70,
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vod.title,
                        style: TextStyles.classWeekContentTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        vod.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyles.classWeekContentDetailTextStyle,
                      )
                    ],
                  ))
            ],
          ),
        ]));
  }
}
