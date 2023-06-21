
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/widget/home/community_box.dart';

import '../../model/post.dart';
import '../../service/community_service.dart';
import '../../widget/appbar.dart';

final communityProvider = FutureProvider.autoDispose<List<Board>>((ref) async {
  return await CommunityService().getBoard();
});

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key, required this.board});

  final Board board;

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends ConsumerState<BoardScreen> {
  final _controller = TextEditingController();
  String newComment = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 키보드 닫기 이벤트
        },
        child: Scaffold(
            appBar: const MainAppbar(hasBackBtn: true,),
            body: Container(
              height: MediaQuery.of(context).size.height,
                child: Stack(children: [
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: SingleChildScrollView(
                      child: Column(children: [
                        CommunityBoxWidget(),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Divider(
                                color: Color.fromRGBO(234, 234, 234, 1),
                                thickness: 1.0)),
                        const Text('comment',
                            style: TextStyles.chatNicknameTextStyle),
                        const SizedBox(
                          height: 8,
                        ),
                        widget.board.comments.isNotEmpty
                            ? Column(
                            children: widget.board.comments
                                .map((e) => CommentItem(comment: e))
                                .toList())
                            : Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text('댓글이 없습니다.',
                              style: TextStyles.underlineTextStyle),
                        )
                      ]))),
              Positioned(child: addComment(), bottom: 0, left: 0, right: 0)
            ]))));
  }

  Widget addComment() => Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color.fromARGB(35, 0, 0, 0), blurRadius: 10)
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        maxLines: null,
        controller: _controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.upload_rounded),
            color: Colors.blue,
          ),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          labelText: 'add a comment...',
        ),
        onChanged: (value) {
          newComment = value;
        },
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
          const EdgeInsets.only(bottom: 10, top: 15, left: 30, right: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.grey[200]),
          child: Text(widget.comment.content,
              style: TextStyles.chatNicknameTextStyle),
        )
      ],
    );
  }
}
