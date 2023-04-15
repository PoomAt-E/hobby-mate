import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/post.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/service/community_service.dart';
import 'package:hobby_mate/widget/profile_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final postProvider = FutureProvider((ref) => CommunityService().getPost());

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final communityPageController = PageController();
  final lessonPageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '취미에 취하다',
          style: TextStyles.appbarTextStyle,
        ),
        leadingWidth: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 246),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    '요즘 Hot한 취미는',
                    style: TextStyles.homeTitleTextStyle,
                  )),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: const HobbyBoxWidget(),
              ),
            ])),
        // const Padding(
        //     padding: EdgeInsets.only(bottom: 15, top: 25),
        //     child: Text(
        //       '커뮤니티',
        //       style: TextStyles.homeTitleTextStyle,
        //     )),
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                alignment: Alignment.center,
                child: CommunityBoxWidget(
                  pageController: communityPageController,
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                    controller: communityPageController,
                    count: 4,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: Colors.indigoAccent,
                      activeStrokeWidth: 10,
                      activeDotScale: 1.7,
                      maxVisibleDots: 5,
                      radius: 8,
                      spacing: 10,
                      dotHeight: 5,
                      dotWidth: 5,
                    )),
              )
            ])),
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 10),
                  child: Text(
                    '추천 강좌',
                    style: TextStyles.homeTitleTextStyle,
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                alignment: Alignment.center,
                child: LessonBoxWidget(
                  pageController: lessonPageController,
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                    controller: lessonPageController,
                    count: 4,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: Colors.indigoAccent,
                      activeStrokeWidth: 10,
                      activeDotScale: 1.7,
                      maxVisibleDots: 5,
                      radius: 8,
                      spacing: 10,
                      dotHeight: 5,
                      dotWidth: 5,
                    )),
              ),
            ]))
      ])),
      // )
    );
  }
}

class HobbyBoxWidget extends StatefulWidget {
  const HobbyBoxWidget({super.key});

  @override
  State<HobbyBoxWidget> createState() => _HobbyBoxWidgetState();
}

class _HobbyBoxWidgetState extends State<HobbyBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final boxWidthSize = MediaQuery.of(context).size.width * 0.3;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 17),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.indigo[50]),
            width: boxWidthSize,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: boxWidthSize - 30,
                    height: boxWidthSize - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/icons/default_profile_image.png'),
                        ))),
                const Text(
                  'Sport',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          );
        });
  }
}

class CommunityBoxWidget extends ConsumerStatefulWidget {
  const CommunityBoxWidget({super.key, required this.pageController});

  final PageController pageController;

  @override
  CommunityBoxWidgettState createState() => CommunityBoxWidgettState();
}

class CommunityBoxWidgettState extends ConsumerState<CommunityBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: widget.pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.1,
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
                          onProfileImagePressed: () {},
                          path: null,
                          type: 1,
                          imageSize: 30),
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
                          '다들 오늘 어디 하시나요? 저는 오늘 치킨을 먹어서 하체하는 날입니다. 저는 요즘 어쩌구 저쩌구 운동에 빠져있네요.. 오늘은 다들 오늘도 화이팅하세요! 저는 요즘 어쩌구 저쩌구 운동에 빠져있네요.. 오늘은 다들 오늘도 화이팅하세요!',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.communityContentTextStyle))
                ],
              ));
        });
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

class LessonBoxWidget extends StatefulWidget {
  const LessonBoxWidget({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<LessonBoxWidget> createState() => _LessonBoxWidgetState();
}

class _LessonBoxWidgetState extends State<LessonBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.2 - 40;
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: widget.pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: size,
                          width: size,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/icons/default_profile_image.png'))),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 20),
                            width:
                                MediaQuery.of(context).size.width - 110 - size,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '기타 강좌',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '취미로 기타는 어떠신가요? 일주일에 두번만 저와 연습해봐요:)',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyles.communityContentTextStyle,
                                )
                              ],
                            ))
                      ],
                    ),
                  ]));
        });
  }
}
