import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hobby_mate/model/post.dart';

import '../../style/style.dart';
import '../profile_image.dart';

class CommunityBoxWidget extends StatefulWidget {
  const CommunityBoxWidget({
    super.key,
    required this.board,
  });

  final Board board;

  @override
  State<CommunityBoxWidget> createState() => CommunityBoxWidgetState();
}

class CommunityBoxWidgetState extends State<CommunityBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                    widget.board.title.length > 20
                        ? '제목: ${widget.board.title.substring(0, 20)}...'
                        : '제목: ${widget.board.title}',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.communityContentTextStyle),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(widget.board.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.communityContentTextStyle)),
          ],
        ));
    ;
    // final post = ref.watch(postProvider);
    // return post.when(
    //   data: (data) {
    //     return PageView.builder(
    //       itemCount: data.length,
    //       itemBuilder: (context, index) {
    //         return Container(
    //           color: Colors.grey[300],
    //           child: Text(data[index].title),
    //         );
    //       },
    //     );
    //   },
    //   loading: () => const CircularProgressIndicator(),
    //   error: (error, stackTrace) => const Text(
    //     'fail to load checkList',
    //     style:
    //         TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w400),
    //   ),
    // );
  }
}
