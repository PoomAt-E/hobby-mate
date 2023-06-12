import 'package:flutter/material.dart';
import 'package:hobby_mate/screen/class/class_vod_player_screen.dart';
import 'package:hobby_mate/widget/profile_image.dart';

import '../../model/vod.dart';
import '../../style/style.dart';

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({super.key, required this.vod});

  final Vod vod;

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                true? Icons.favorite_rounded: Icons.favorite_border,
                color: Colors.red,
              ))
        ],
        backgroundColor: Colors.white,
        expandedHeight: 200,
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(widget.vod.vodName,
                  style: TextStyle(color: Colors.white, fontSize: 12))),
          background: Image(
            image: AssetImage('assets/images/default_class.png'),
            fit: BoxFit.cover,
    color: Colors.white.withOpacity(0.8), colorBlendMode: BlendMode.modulate,
          ),
        ),
      ),
      SliverFillRemaining(
          child: Flex(direction: Axis.vertical, children: [
        Expanded(

            child: SingleChildScrollView(
                child:
            Column(
          children: ['통기타 시작하기', '튜닝하기', '악보 읽기', '코드 읽기', '튜닝하기', '악보 읽기', '코드 읽기']
              .map(
                (e) => ExpansionTile(
                    title: Text(
                      e,
                    ),
                    collapsedTextColor:
                        e == '통기타 시작하기' ? Colors.black : Colors.black45,
                    trailing: e == '통기타 시작하기'
                        ? Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: Colors.black87,
                          )
                        : Icon(
                            Icons.lock,
                            size: 20,
                            color: Colors.black45,
                          ),
                    children: [ClassWeekBox(title: e)]),
              )
              .toList(),
        ))),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              ProfileImage(onProfileImagePressed: (){}, path: null, imageSize: 50),
              SizedBox(width: 10),
              Text('강사: ${widget.vod.ownerId}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ],
          ),
        ),
        InkWell(
          onTap: () => showDialog(context: context, builder: (context) => AlertDialog(
            title: Text('결제하기'),
            content: Text('\'${widget.vod.vodName}\' 구매하시겠습니까?\n금액: 45,000원'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('취소')),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('확인')),
            ],
          )),
          child: Container(
            child: Text(
              '\'45,000원\' 구매하기',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18),
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.teal,
            alignment: Alignment.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 4개의 강의',
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text('총 4시간 30분',
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
        ),
        Container()
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
