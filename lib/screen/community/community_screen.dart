import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/service/community_service.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:hobby_mate/widget/home/community_box.dart';

import '../../style/style.dart';

final communityScreenProvider =
    FutureProvider((ref) => CommunityService().getPost());

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppbar(),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const CommunityBoxWidget(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    width: double.infinity,
                    height: 1,
                    color: Color.fromARGB(20, 0, 0, 0),
                  )
                ],
              );
            },
          ),
        )));
  }
}
