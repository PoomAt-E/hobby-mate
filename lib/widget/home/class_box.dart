import 'package:flutter/material.dart';
import 'package:hobby_mate/screen/class/class_detail_screen.dart';

import '../../style/style.dart';

class ClassBoxWidget extends StatefulWidget {
  const ClassBoxWidget({super.key});

  @override
  State<ClassBoxWidget> createState() => _ClassBoxWidgetState();
}

class _ClassBoxWidgetState extends State<ClassBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.2 - 40;
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const ClassDetailScreen()) // 리버팟 적용된 HomeScreen 만들기
            ),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage('assets/images/default_class.png'))),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width - 110 - size,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '통기타 시작하기',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '100명중 1명만이 터득하는 통기타의 비밀을 알려드립니다.',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: TextStyles.classContentTextStyle,
                          )
                        ],
                      ))
                ],
              ),
            ])));
    ;
  }
}
