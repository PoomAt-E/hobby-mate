import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/Estimate.dart';
import 'package:hobby_mate/service/auth_service.dart';
import 'package:hobby_mate/service/class_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:intl/intl.dart';

import '../../service/match_service.dart';
import '../estimate/estimate_screen.dart';
import '../sign/signup_profile_screen.dart';
import '../../model/matching.dart';
import '../../model/member.dart';

enum PriceType { total, hourly }

final priceProvider = StateProvider((ref) => '0');
final priceDetailProvider = StateProvider((ref) => '');

class MenteeScreen extends ConsumerStatefulWidget {
  const MenteeScreen({Key? key}) : super(key: key);

  @override
  MenteeScreenState createState() => MenteeScreenState();
}

class MenteeScreenState extends ConsumerState<MenteeScreen> {
  PriceType priceType = PriceType.hourly;
  final textEditingController = TextEditingController();
  late FutureProvider<List<Matching>> matchProvider;

  @override
  void initState() {
    matchProvider = FutureProvider((ref) => MatchService().getMatch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final price = ref.watch(priceProvider);
    final matches = ref.watch(matchProvider);
    final priceDetail = ref.watch(priceDetailProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 50,
          title: const Center(
              child: Text('프로필',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EstimateScreen()));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
            future: AuthService().getMyInfo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 20),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.profileImageURL!),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      snapshot.data!.nickname,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Major: ${snapshot.data!.majors![0]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Email: ${snapshot.data!.email}',
                                      style: const TextStyle(fontSize: 16),
                                    ),

                                    // Container(
                                    //     margin: const EdgeInsets.only(top: 20),
                                    //     child: Row(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       children: [
                                    //         RowButton(
                                    //           data: '멘토',
                                    //           onGenderChoosed: () =>
                                    //               setState(() {
                                    //             priceType = PriceType.hourly;
                                    //           }),
                                    //           state:
                                    //               priceType == PriceType.hourly,
                                    //         ),
                                    //         SizedBox(
                                    //             width: MediaQuery.of(context)
                                    //                     .size
                                    //                     .width *
                                    //                 0.02),
                                    //         RowButton(
                                    //             data: '멘티',
                                    //             onGenderChoosed: () =>
                                    //                 setState(() {
                                    //                   priceType =
                                    //                       PriceType.total;
                                    //                 }),
                                    //             state: priceType ==
                                    //                 PriceType.total),
                                    //       ],
                                    //     )),
                                    const SizedBox(height: 20),
                                    if (snapshot.data!.role == 'MENTOR') ...[
                                      const Text(
                                        '내가 등록한 Class',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey[300],
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[200]),
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: const Text(
                                            '강좌명 : 통기타 시작하기.\n\n강좌내용 : 100명중 1명만이 터득하는 통기타 수업\n\n강좌수 : 5개\n\n금액 : 50000원',
                                            style: TextStyle(
                                                overflow: TextOverflow.clip,
                                                fontSize: 14,
                                                height: 1.2),
                                          )),
                                      const SizedBox(height: 20),
                                      const Text(
                                        '나에게 온 요청',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey[300],
                                      ),
                                      ...[
                                        matches.when(
                                            data: (comments) {
                                              if (comments.isEmpty) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: const Text('요청이 없습니다.',
                                                      style: TextStyles
                                                          .underlineTextStyle),
                                                );
                                              } else {
                                                return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: comments
                                                        .map((e) =>
                                                            FutureBuilder(
                                                                future: AuthService()
                                                                    .getMemberInfo(e
                                                                        .menteeEmail),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return Container(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                15),
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.grey[
                                                                                200]!,
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              '닉네임: ${snapshot.data!.nickname}',
                                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                MatchService().acceptMatch(e.matchId);
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('매칭을 수락했습니다.')));
                                                                              },
                                                                              child: Text('매칭 수락', style: TextStyle(color: Colors.black)),
                                                                              style: ElevatedButton.styleFrom(primary: Colors.yellow[700]),
                                                                            ),
                                                                          ],
                                                                        ));
                                                                  } else {
                                                                    return const CircularProgressIndicator();
                                                                  }
                                                                }))
                                                        .toList());
                                              }
                                            },
                                            error: (error, stack) =>
                                                Text('error: $error'),
                                            loading: () =>
                                                const CircularProgressIndicator())
                                      ]
                                    ] else ...[
                                      const Text(
                                        '내가 구매한 Class',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey[300],
                                      ),
                                    ]
                                  ]))),
                      Positioned(
                          bottom: 0,
                          child: InkWell(
                              onTap: () {
                                final estimate = Estimate(
                                    id: 0,
                                    writer: 'user',
                                    date: DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()),
                                    price: price,
                                    detail: priceDetail,
                                    priceType: priceType == PriceType.hourly
                                        ? true
                                        : false,
                                    category: '');
                                ClassService().sendEstimate(estimate);
                                Navigator.of(context).pop();
                              } // 리버팟 적용된 HomeScreen 만들기
                              ,
                              child: Container(// 여기 없으면 왜 rowbutton 안 먹는거에요 ?
                                  )))
                    ],
                  ));
            }));
  }
}

class MatchItem extends ConsumerStatefulWidget {
  const MatchItem({super.key, required this.matchitems});

  final Matching matchitems;

  @override
  _MatchItemState createState() => _MatchItemState();
}

class _MatchItemState extends ConsumerState<MatchItem> {
  late FutureProvider<Member> provider;

  @override
  void initState() {
    provider = FutureProvider((ref) async {
      // final shredPref = await SharedPreferences.getInstance();
      // final email = shredPref.getString(widget.matchitems.menteeEmail);
      return await AuthService().getMemberInfo(widget.matchitems.menteeEmail);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ref.watch(provider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ProfileButton(
        //   nickname: widget.comment.id,
        //   path: ,
        //   id: widget.comment.id,
        // ),
        Container(
          margin:
              const EdgeInsets.only(bottom: 10, top: 15, left: 10, right: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.grey[200]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Text(
                    nickname.asData?.value.nickname ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "님으로 부터 요청이 도착했습니다",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                  // onTap: () => onButtonClick("test111@gmail.com"),
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
            ],
          ),
        )
      ],
    );
  }
}
