import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hobby_mate/widget/home/class_box.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        backgroundColor: Colors.white,
        expandedHeight: 100,
        flexibleSpace: FlexibleSpaceBar(
          title: Text('오늘의 추천 강좌',
              style: TextStyle(color: Colors.black, fontSize: 16)),
          background: Container(
            color: Colors.amber,
          ),
        ),
      ),
      SliverFillRemaining(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Flex(direction: Axis.vertical, children: [
                Expanded(
                    child: Column(
                        children:
                            [1, 2, 3].map((e) => ClassBoxWidget()).toList()))
              ])))
    ]));
  }
}
