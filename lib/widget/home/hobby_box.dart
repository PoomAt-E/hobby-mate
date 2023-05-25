import 'package:flutter/material.dart';
import 'package:hobby_mate/style/style.dart';

import '../../screen/main/home_screen.dart';

class HobbyBoxWidget extends StatefulWidget {
  const HobbyBoxWidget({super.key, required this.hobbyList, required this.size});

  final List<Hobby> hobbyList;
  final double size;

  @override
  State<HobbyBoxWidget> createState() => _HobbyBoxWidgetState();
}

class _HobbyBoxWidgetState extends State<HobbyBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final boxWidthSize = MediaQuery.of(context).size.width * 0.3;
    return
      ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.hobbyList.length,
        itemBuilder: (context, index) {
          return Container(
            margin:
                const EdgeInsets.only(right: 17, top: 10, bottom: 10, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(21, 0, 0, 0),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(1, 3),
                  )
                ]),
            // border: Border.all(color: Colors.black26, width: 1)),
            height: widget.size - 40,
            width: widget.size - 40,
            padding: const EdgeInsets.all(15),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    width: widget.size - 40,
                    height: widget.size - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.hobbyList[index].icon),
                        ))),
                Positioned(bottom: 0,
                    child: Text(
                  widget.hobbyList[index].title,
                  style: TextStyles.hobbyTitleTextStyle,
                ))
              ])


          );
        });
  }
}
