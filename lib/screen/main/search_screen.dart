import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/vod.dart';
import 'package:hobby_mate/service/search_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/widget/home/class_box.dart';

import '../../provider/search_provider.dart';
import '../../widget/profile_image.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

// final searchedListProvider = FutureProvider<List<String>>((ref) async {
//   final text = ref.watch(searchTextProvider);
//   if (text.isEmpty) {
//     return [];
//   } else {
//     return SearchService().search(text);
//   }
// });

final searchProvider =
    StateNotifierProvider<SearchProvider, List<String>>((ref) {
  return SearchProvider();
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.text = ''});

  final String text;

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.text;
    ref.read(searchProvider.notifier).search(widget.text);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(searchProvider);
    final text = ref.watch(searchTextProvider);
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Expanded(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      ref.read(searchProvider.notifier).search(text);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.teal,
                    ))
              ],
            )),
        Expanded(
          child: SearchListWidget(list: [
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
          ]),
        ),
      ],
    )));
  }
}

class SearchListWidget extends ConsumerWidget {
  const SearchListWidget({super.key, required this.list});

  final List<Vod> list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(searchTextProvider);

    Widget searchText(String searchedText) {
      List<String> splitText = searchedText.split(title);

      final List<TextSpan> children = [];
      for (int i = 0; i < splitText.length; i++) {
        children.add(TextSpan(
            text: splitText[i], style: TextStyles.classWeekTitleTextStyle));
        if (i != splitText.length - 1) {
          children.add(TextSpan(
            text: title,
            style: TextStyles.appbarIconTextStyle,
          ));
        }
      }
      return Text.rich(TextSpan(children: children),
          textAlign: TextAlign.start);
    }

    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          Text(
            '검색 결과',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ProfileImage(
                    onProfileImagePressed: () {}, path: null, imageSize: 50),
                const SizedBox(width: 10),
                Text(
                  '강사: 테니스의 공주',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ProfileImage(
                    onProfileImagePressed: () {}, path: null, imageSize: 50),
                const SizedBox(width: 10),
                Text(
                  '강사: 테니스의 왕자',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Divider(),
          ...list
              .map((e) => ClassBoxWidget(vod: e))
              // Container(
              //       alignment: Alignment.centerLeft,
              //       margin: const EdgeInsets.symmetric(
              //         horizontal: 20,
              //       ),
              //       padding: const EdgeInsets.symmetric(vertical: 15),
              //       decoration: const BoxDecoration(
              //           border: Border(
              //               bottom: BorderSide(color: Colors.black12, width: 1))),
              //       child: searchText(e.vodName),
              //     ))
              .toList()
        ]));
  }
}
