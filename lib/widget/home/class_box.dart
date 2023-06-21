import 'package:flutter/material.dart';
import 'package:hobby_mate/screen/class/class_detail_screen.dart';

import '../../model/vod.dart';
import '../../style/style.dart';

class ClassBoxWidget extends StatefulWidget {
  const ClassBoxWidget({super.key, required this.vodGroup});

  final VodGroup vodGroup;

  @override
  State<ClassBoxWidget> createState() => _ClassBoxWidgetState();
}

class _ClassBoxWidgetState extends State<ClassBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ClassDetailScreen(vodGroupId: widget.vodGroup.id))
            ),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image:  DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(widget.vodGroup.thumbnailURL))),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.vodGroup.vodGroupName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.vodGroup.vodGroupName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
