import 'package:flutter/cupertino.dart';

import '../../model/post.dart';
import '../../style/style.dart';
import '../profile_image.dart';

class CommunityBoxWidget extends StatefulWidget {
  const CommunityBoxWidget({
    super.key,
    // required this.posts
  });

  // final Post posts;

  @override
  State<CommunityBoxWidget> createState() => CommunityBoxWidgetState();
}

class CommunityBoxWidgetState extends State<CommunityBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileImage(
                    onProfileImagePressed: () {}, path: null, imageSize: 30),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  '다이어터 우중',
                  style: TextStyles.communityWriterTextStyle,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            // Text('오늘은 하체하는 날'),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    '다들 오늘 어디 하시나요? 저는 오늘 치킨을 먹어서 하체하는 날입니다. 저는 요즘 어쩌구 저쩌구 운동에 빠져있네요.. 오늘은 다들 오늘도 화이팅하세요! ',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.communityContentTextStyle))
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
