import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/post.dart';
import 'package:hobby_mate/screen/community/new_post_screen.dart';
import 'package:hobby_mate/screen/community/post_screen.dart';
import 'package:hobby_mate/service/community_service.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:hobby_mate/widget/home/community_box.dart';

import '../../style/style.dart';
import '../../widget/profile_image.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final communityProvider =
      FutureProvider((ref) => CommunityService().getBoard());

  @override
  Widget build(BuildContext context) {
    final boards = ref.watch(communityProvider);
    return Scaffold(
      appBar: const MainAppbar(),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: boards.when(
                  data: (boards) {
                    if (boards.isEmpty) {
                      return const Center(child: Text('게시글이 없습니다.'));
                    } else {
                      return ListView.builder(
                        itemCount: boards.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BoardScreen(
                                                        board: boards[index])));
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              boards[index]
                                                                  .title,
                                                              maxLines: 4,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyles
                                                                  .communityContentTextStyle),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          ProfileImage(
                                                              onProfileImagePressed:
                                                                  () {},
                                                              path: null,
                                                              imageSize: 20),
                                                          const SizedBox(
                                                            width: 7,
                                                          ),
                                                          Text(
                                                            boards[index]
                                                                .userId
                                                                .toString(),
                                                            style: TextStyles
                                                                .communityWriterTextStyle,
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Column(children: [
                                                      Text(
                                                          boards[index]
                                                              .comments
                                                              .length
                                                              .toString(),
                                                          style: TextStyles
                                                              .communityContentTextStyle),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Icon(Icons.comment,
                                                          color: Colors.grey[300], size: 20,)
                                                    ]))
                                              ]))),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    width: double.infinity,
                                    height: 1,
                                    color: const Color.fromARGB(20, 0, 0, 0),
                                  )
                                ],
                              ));
                        },
                      );
                    }
                  },
                  error: (e, s) {
                    return const Center(child: Text('게시글을 불러오는데 실패했습니다.'));
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }
}
