import 'package:flutter/material.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/model/vod.dart';
import 'package:hobby_mate/screen/class/class_detail_screen.dart';
import 'package:intl/intl.dart';

import '../../service/match_service.dart';

class MentorProfileScreen extends StatefulWidget {
  const MentorProfileScreen({super.key, required this.member});

  final Member member;

  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 50,
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          actions: const [SizedBox(width: 50)],
          title: const Center(
              child: Text('프로필',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black))),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                    widget.member.profileImageURL!),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.member.nickname,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Hobby : ${widget.member.interests?[0] ?? ''}Major : ${widget.member.majors?[0] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Email: ${widget.member.email}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 20),
                              const Text(
                                '내가 등록한 Class',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassDetailScreen(
                                                  vodGroup: VodGroup(
                                                      id:
                                                          '6492f531eb56265b530760f2',
                                                      vodGroupName: '정승환노래교실',
                                                      vodCount: 4,
                                                      thumbnailURL:
                                                          'https://identitylessimgserver.s3.ap-northeast-2.amazonaws.com/streaming/vodGroup/thumbnail/Jung_Seung-hwan_%28singer%29_2019-09-27.png',
                                                      keyword: null),
                                                )));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Text(
                                        '강좌명 : 통기타 시작하기.\n\n강좌내용 : 100명중 1명만이 터득하는 통기타 수업\n\n강좌수 : 5개\n\n금액 : 50000원',
                                      ))),
                              const SizedBox(height: 20),
                            ]))),
                Positioned(
                    bottom: 0,
                    child: InkWell(
                        onTap: () {
                          MatchService().saveMatch(widget.member.email);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          color: Colors.yellow,
                          width: MediaQuery.of(context).size.width,
                          child: Text('Match!'),
                        )))
              ],
            )));
  }
}
