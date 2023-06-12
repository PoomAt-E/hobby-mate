import 'package:flutter/material.dart';
import 'package:hobby_mate/screen/main/search_screen.dart';
import 'package:hobby_mate/style/style.dart';

import '../../screen/main/home_screen.dart';

class HobbyBoxWidget extends StatefulWidget {
  const HobbyBoxWidget({super.key, required this.hobbyList});

  final List<Hobby> hobbyList;

  @override
  State<HobbyBoxWidget> createState() => _HobbyBoxWidgetState();
}

class _HobbyBoxWidgetState extends State<HobbyBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
            childAspectRatio: 1 / 1, //item 의 가로 2, 세로 2 의 비율
            mainAxisSpacing: 0, //수평 Padding
            crossAxisSpacing: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.hobbyList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreen(text: widget.hobbyList[index].title)));
            },
            child: SizedBox(
                height: 80,
                width: 80,
                child: Column(children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(widget.hobbyList[index].icon),
                          ))),
                  Text(
                    widget.hobbyList[index].title,
                    style: TextStyles.hobbyTitleTextStyle,
                  )
                ]))
          );
        });
  }
}
