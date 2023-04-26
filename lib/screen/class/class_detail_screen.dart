import 'package:flutter/material.dart';
import 'package:hobby_mate/screen/class/class_vod_player_screen.dart';

import '../../style/style.dart';

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({super.key});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        backgroundColor: Colors.white,
        expandedHeight: 200,
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(5)),
              child: Text('통기타 시작하기',
                  style: TextStyle(color: Colors.white, fontSize: 12))),
          background: Image(
            image: AssetImage('assets/images/default_class.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SliverFillRemaining(
          child: Flex(direction: Axis.vertical, children: [
        Expanded(
            child: Column(
          children: ['통기타 시작하기', '튜닝하기', '악보 읽기', '코드 읽기']
              .map((e) => ExpansionTile(
                  title: Text(
                    e,
                  ),
                  children: [ClassWeekBox(title: e)]))
              .toList(),
        ))
      ]))
    ]));
  }
}

class ClassWeekBox extends StatelessWidget {
  const ClassWeekBox({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.1;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const VideoPlayerScreen()) // 리버팟 적용된 HomeScreen 만들기
                      ),
                  child: Stack(
                    children: [
                      Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/default_class.png'))),
                      ),
                      SizedBox(
                        height: size,
                        width: size,
                        child: Center(
                            child: Icon(
                          Icons.play_circle,
                          color: Colors.white.withOpacity(0.5),
                          size: 40,
                        )),
                      )
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width - size - 70,
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '튜닝하기',
                        style: TextStyles.classWeekContentTextStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '본격적으로 통기타를 다뤄보기 전, 튜닝에 대해 알아봅시다',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyles.classWeekContentDetailTextStyle,
                      )
                    ],
                  ))
            ],
          ),
        ]));
  }
}
