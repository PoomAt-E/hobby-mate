import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/model/vod.dart';
import 'package:hobby_mate/screen/class/class_detail_screen.dart';
import 'package:hobby_mate/screen/main/mentor_profile_screen.dart';
import 'package:hobby_mate/service/search_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/widget/home/class_box.dart';

import '../../provider/search_provider.dart';
import '../../widget/profile_image.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.text = ''});

  final String text;

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final searchMemberProvider =
      StateNotifierProvider<SearchProvider, List<Member>>((ref) {
    return SearchProvider();
  });
  final searchClassProvider =
      StateNotifierProvider<SearchProvider, List<Member>>((ref) {
    return SearchProvider();
  });

  @override
  void initState() {
    _controller.text = widget.text;
    ref.read(searchMemberProvider.notifier).search(widget.text);
    ref.read(searchClassProvider.notifier).search(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchedClass = ref.watch(searchClassProvider);
    final searchedMember = ref.watch(searchMemberProvider);
    final text = ref.watch(searchTextProvider);
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  enabled: true,
                  controller: _controller,
                  onChanged: (text) {
                    ref.read(searchTextProvider.notifier).state = text;
                  },
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                      hintText: '어떤 취미를 찾으시나요?',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                      ),
                      suffixIcon: text == ''
                          ? null
                          : IconButton(
                              onPressed: () {
                                _controller.clear();
                                ref.read(searchTextProvider.notifier).state =
                                    '';
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.teal,
                              ))),
                )),
                IconButton(
                    onPressed: () {
                      ref.read(searchClassProvider.notifier).search(text);
                      ref.read(searchMemberProvider.notifier).search(text);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.teal,
                    ))
              ],
            )),
        Expanded(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '검색 결과',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    ...searchedMember.map((e) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MentorProfileScreen(member: e)));
                          },
                          child: Row(
                            children: [
                              ProfileImage(
                                  onProfileImagePressed: () {},
                                  path: e.profileImageURL,
                                  imageSize: 30),
                              const SizedBox(width: 10),
                              Text(
                                '강사: ${e.nickname}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ))),
                    const Divider(),
                    ...[
                      Vod(
                        ownerId: "1",
                        vodName: '테니스 시작하기',
                        vodGroupId: "1",
                        vodLengthH: 1,
                        vodLengthM: 30,
                        vodLengthS: 1,
                        vodType: "1",
                        id: "1",
                        vodUrl: "1",
                      ),
                      Vod(
                        ownerId: "1",
                        vodName: '테니스 중급 과정',
                        vodGroupId: "1",
                        vodLengthH: 1,
                        vodLengthM: 30,
                        vodLengthS: 1,
                        vodType: "1",
                        id: "1",
                        vodUrl: "1",
                      )
                    ].map((e) => ClassBoxWidget(vod: e)).toList()
                  ])),
        )
      ]),
    ));
  }

  Widget searchText(String searchedText) {
    List<String> splitText = searchedText.split(ref.read(searchTextProvider));

    final List<TextSpan> children = [];
    for (int i = 0; i < splitText.length; i++) {
      children.add(TextSpan(
          text: splitText[i], style: TextStyles.classWeekTitleTextStyle));
      if (i != splitText.length - 1) {
        children.add(TextSpan(
          text: ref.read(searchTextProvider),
          style: TextStyles.appbarIconTextStyle,
        ));
      }
    }
    return Text.rich(TextSpan(children: children), textAlign: TextAlign.start);
  }
}
