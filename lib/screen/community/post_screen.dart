import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/widget/home/community_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/post.dart';
import '../../service/community_service.dart';
import '../../widget/appbar.dart';
import '../../widget/profile_image.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key, required this.board});

  final Board board;

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends ConsumerState<BoardScreen> {
  final _controller = TextEditingController();
  late FutureProvider<List<Comment>> commentProvider;

  @override
  void initState() {
    commentProvider = FutureProvider(
            (ref) => CommunityService().getComments(widget.board.boardId));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentProvider);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 키보드 닫기 이벤트
        },
        child: Scaffold(
            appBar: const MainAppbar(
              hasBackBtn: true,
            ),
            body: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Stack(children: [
                  Container(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerRight,
                                    color: Colors.grey[300],
                                    child: Row(
                                      children: [
                                        ProfileImage(
                                            onProfileImagePressed: () {},
                                            path: null,
                                            imageSize: 20),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                          widget.board.userId.toString(),
                                          style: TextStyles.communityWriterTextStyle,
                                        )
                                      ],
                                    )),
                                CommunityBoxWidget(board: widget.board),
                                Container(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                    child: const Divider(
                                        color: Color.fromRGBO(234, 234, 234, 1),
                                        thickness: 1.0)),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  alignment: Alignment.center,
                                  child: const Text('comment',
                                      style: TextStyles.chatNicknameTextStyle),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ...[
                                  comments.when(
                                      data: (comments) {
                                        if (comments.isEmpty) {
                                          return Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.only(
                                                top: 10),
                                            child: const Text('댓글이 없습니다.',
                                                style:
                                                TextStyles.underlineTextStyle),
                                          );
                                        } else {
                                          return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: comments
                                                  .map((e) =>
                                                  CommentItem(comment: e))
                                                  .toList());
                                        }
                                      },
                                      error: (error, stack) =>
                                          Text('error: $error'),
                                      loading: () =>
                                      const CircularProgressIndicator())
                                ]
                              ]))),
                  Positioned(bottom: 0, left: 0, right: 0, child: addComment())
                ]))));
  }

  Widget addComment() =>
      Container(
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color.fromRGBO(234, 234, 234, 1), width: 1))),
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
            maxLines: null,
            controller: _controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                onPressed: () async {
                  final sharedPref = await SharedPreferences.getInstance();
                  final userId = sharedPref.getString('email');
                  CommunityService().saveComments({
                    'boardId': widget.board.boardId,
                    'content': _controller.text,
                    'userId': userId,
                    'good': 0
                  }).then((value) {
                    _controller.clear();
                    ref.refresh(commentProvider);
                  });
                },
                icon: const Icon(Icons.send),
                color: Colors.blue,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              labelText: '댓글 작성',
            ),
          ));
}

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
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
          child: Text(widget.comment.content,
              style: const TextStyle(fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
        )
      ],
    );
  }
}
