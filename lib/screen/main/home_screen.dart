import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/screen/main/bottom_nav.dart';
import 'package:hobby_mate/screen/main/profile_screen.dart';
import 'package:hobby_mate/screen/main/search_screen.dart';
import 'package:hobby_mate/service/auth_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/service/community_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widget/home/community_box.dart';
import '../../widget/home/hobby_box.dart';
import '../../widget/home/class_box.dart';

final popularPostProvider =
    FutureProvider((ref) => CommunityService().getPopularPost());

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
    Hobby(title: '기타', icon: 'assets/icons/icon_guitar.png')
  ];

  final communityPageController = PageController();
  final classPageController = PageController();
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
            },
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    '🔥 요즘 Hot한 취미는',
                    style: TextStyles.homeTitleTextStyle,
                  )),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: HobbyBoxWidget(hobbyList: hobbyList, size: MediaQuery.of(context).size.height * 0.2),
              ),
            ])),
        const SizedBox(
          height: 20,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          '🪧 오늘의 커뮤니티',
                          style: TextStyles.homeTitleTextStyle,
                        ),
                        InkWell(
                          onTap: () =>
                              ref.read(bottomNavProvider.notifier).state = 2,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '전체보기  ',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.black54,
                                )
                              ]),
                        )
                      ])),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                alignment: Alignment.center,
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: communityPageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return const CommunityBoxWidget();
                    }),
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
              Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          '👩🏻‍💻 추천 강좌',
                          style: TextStyles.homeTitleTextStyle,
                        ),
                        InkWell(
                          onTap: () =>
                              ref.read(bottomNavProvider.notifier).state = 1,
                          child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                                  '전체보기  ',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.black54,
                                )
                              ]),
                        )
                      ])),
              Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: classPageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const ClassBoxWidget();
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
