import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/service/search_service.dart';
import 'package:hobby_mate/style/style.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

final searchedListProvider = FutureProvider<List<String>>((ref) async {
  final text = ref.watch(searchTextProvider);
  if (text.isEmpty) {
    return [];
  } else {
    return SearchService().search(text);
  }
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(searchedListProvider);
    final text = ref.watch(searchTextProvider);
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      enabled: true,
                      controller: _controller,
                      onChanged: (text) {
                        ref.read(searchTextProvider.notifier).state = text;
                      },
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          hintText: '어떤 취미를 찾으시나요?',
                          hintStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.amber, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.amber, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.amber, width: 2),
                          ),
                          suffixIcon: text == ''
                              ? const Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                )
                              : IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                    ref
                                        .read(searchTextProvider.notifier)
                                        .state = '';
                                  },
                                  icon: const Icon(Icons.clear, color: Colors.amber,))),
                    )),
                Expanded(
                    child: data.when(
                  data: (data) => SearchListWidget(list: data),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, s) => const Center(
                    child: Text('Error'),
                  ),
                ))
              ],
            )));
  }
}

class SearchListWidget extends ConsumerWidget {
  const SearchListWidget({super.key, required this.list});

  final List<String> list;

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
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list
          .map((e) => Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1))),
                child: searchText(e),
              ))
          .toList(),
    ));
  }
}
