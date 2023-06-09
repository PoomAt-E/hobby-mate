import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/main/bottom_nav.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';
import 'package:hobby_mate/screen/main/search_screen.dart';
import 'package:hobby_mate/service/auth_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/service/community_service.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/vod.dart';
import '../../widget/home/hobby_box.dart';
import '../../widget/home/class_box.dart';



class Hobby {
  final String title;
  final String icon;

  Hobby({required this.title, required this.icon});
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  List<Hobby> hobbyList = [
    Hobby(title: '블로그', icon: 'assets/icons/icon_blog.png'),
    Hobby(title: '주식', icon: 'assets/icons/icon_stock.png'),
    Hobby(title: '골프', icon: 'assets/icons/icon_golf.png'),
    Hobby(title: '디자인', icon: 'assets/icons/icon_design.png'),
    Hobby(title: '요리', icon: 'assets/icons/icon_cooking.png'),
    Hobby(title: '필라테스', icon: 'assets/icons/icon_pilates.png'),
    Hobby(title: '헬스', icon: 'assets/icons/icon_health.png'),
    Hobby(title: '테니스', icon: 'assets/icons/icon_tennis.png'),
    Hobby(title: '요가', icon: 'assets/icons/icon_yoga.png'),
    Hobby(title: '서핑', icon: 'assets/icons/icon_surf.png'),
    Hobby(title: '노래', icon: 'assets/icons/icon_guitar.png')
  ];

  final popularPostProvider =
  FutureProvider((ref) => CommunityService().getPopularBoard());

  final communityPageController = PageController();
  final classPageController = PageController();
  int column = 0;

  @override
  Widget build(BuildContext context) {
    column = hobbyList.length ~/ 4;
    if (hobbyList.length % 4 != 0) column += 1;

    return Scaffold(
      appBar: const MainAppbar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
            },
            child: TextField(
              enabled: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              },
              decoration: InputDecoration(
                // filled: true,
                // fillColor: Colors.teal[50]!.withOpacity(0.5),
                hintText: '어떤 취미를 찾으시나요?',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                height: 90 * column.toDouble() + 10,
                child: HobbyBoxWidget(
                  hobbyList: hobbyList,
                ),
              )
            ])),
        // const SizedBox(
        //   height: 20,
        // ),
        // Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        //     color: Colors.white,
        //     child:
        //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       Padding(
        //           padding: const EdgeInsets.only(bottom: 15),
        //           child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               mainAxisSize: MainAxisSize.max,
        //               children: [
        //                 const Text(
        //                   '🪧 오늘의 커뮤니티',
        //                   style: TextStyles.homeTitleTextStyle,
        //                 ),
        //                 InkWell(
        //                   onTap: () =>
        //                       ref.read(bottomNavProvider.notifier).state = 2,
        //                   child: Row(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: const [
        //                         Text(
        //                           '전체보기  ',
        //                           style: TextStyle(
        //                               fontSize: 13, color: Colors.black54),
        //                         ),
        //                         Icon(
        //                           Icons.arrow_forward_ios,
        //                           size: 12,
        //                           color: Colors.black54,
        //                         )
        //                       ]),
        //                 )
        //               ])),
        //       Container(
        //         height: MediaQuery.of(context).size.height * 0.2,
        //         width: double.infinity,
        //         alignment: Alignment.center,
        //         child: PageView.builder(
        //             scrollDirection: Axis.horizontal,
        //             controller: communityPageController,
        //             physics: const BouncingScrollPhysics(),
        //             itemCount: 4,
        //             itemBuilder: (context, index) {
        //               return const CommunityBoxWidget();
        //             }),
        //       ),
        //       Container(
        //         width: double.infinity,
        //         alignment: Alignment.center,
        //         child: SmoothPageIndicator(
        //             controller: communityPageController,
        //             count: 4,
        //             effect: const ScrollingDotsEffect(
        //               activeDotColor: Colors.indigoAccent,
        //               activeStrokeWidth: 10,
        //               activeDotScale: 1.7,
        //               maxVisibleDots: 5,
        //               radius: 8,
        //               spacing: 10,
        //               dotHeight: 5,
        //               dotWidth: 5,
        //             )),
        //       )
        //     ])),
        // const SizedBox(
        //   height: 20,
        // ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '인기 클래스',
                          style: TextStyles.homeTitleTextStyle,
                        ),
                        // InkWell(
                        //   onTap: () =>
                        //       ref.read(bottomNavProvider.notifier).state = 1,
                        //   child: const Row(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           '전체보기  ',
                        //           style: TextStyle(
                        //               fontSize: 13, color: Colors.black54),
                        //         ),
                        //         Icon(
                        //           Icons.arrow_forward_ios,
                        //           size: 12,
                        //           color: Colors.black54,
                        //         )
                        //       ]),
                        // )
                      ])),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: 120,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: classPageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ClassBoxWidget(
                          vodGroup: VodGroup(id: '6492f531eb56265b530760f2', vodGroupName: '정승환노래교실', vodCount: 4, thumbnailURL: 'https://identitylessimgserver.s3.ap-northeast-2.amazonaws.com/streaming/vodGroup/thumbnail/Jung_Seung-hwan_%28singer%29_2019-09-27.png', keyword: null),
                        );
                      })),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                    controller: classPageController,
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

  onProfileIconClicked() async {
    final pref = await SharedPreferences.getInstance();
    final email = pref.getString('email')!;
    Member member = await AuthService().getMemberInfo(email);

    pushProfileScreen(member);
  }

  pushProfileScreen(Member member) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ProfileScreen(member: member)));
}
