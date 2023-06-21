import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/post.dart';
import 'package:hobby_mate/screen/community/new_post_screen.dart';
import 'package:hobby_mate/screen/community/post_screen.dart';
import 'package:hobby_mate/service/community_service.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:hobby_mate/widget/home/community_box.dart';


final communityScreenProvider =
    FutureProvider((ref) => CommunityService().getBoard());

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
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NewPostScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
            child: Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount:10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BoardScreen(
                                board: Board(
                                    boardId: 1,
                                    title: 'title',
                                    content: 'content',
                                    location: 'location',
                                    comments: [],
                                    userId: 1,
                                    views: 1))));
                      },
                      child: const CommunityBoxWidget(),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      width: double.infinity,
                      height: 1,
                      color: const Color.fromARGB(20, 0, 0, 0),
                    )
                  ],
                );
              },
            ),
          ),

        ])));
  }
}
