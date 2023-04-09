import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/config/style.dart';
import 'package:hobby_mate/service/community_service.dart';

final postProvider = FutureProvider((ref) => CommunityService().getPost());

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '취미에 취하다',
            style: TextStyles.appbarTextStyle,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black54),
              onPressed: () {},
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
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  '요즘 Hot한 취미는',
                  style: TextStyles.appbarTextStyle,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height: 200,
                  color: Colors.grey[300],
                ),
                const Text(
                  '커뮤니티',
                  style: TextStyles.appbarTextStyle,
                ),
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const CommunityWidget(),
                ),
                const Text(
                  '추천강좌',
                  style: TextStyles.appbarTextStyle,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height: 200,
                  color: Colors.grey[300],
                ),
              ])),
        ));
  }
}

class CommunityWidget extends ConsumerWidget {
  const CommunityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider);
    return post.when(
      data: (data) {
        return PageView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey[300],
              child: Text(data[index].title),
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Text(
        'fail to load checkList',
        style:
            TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w400),
      ),
    );
  }
}
