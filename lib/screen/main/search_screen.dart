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
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Colors.white,
          leadingWidth: 0,
          title: TextField(
            controller: _controller,
            onChanged: (text) {
              ref.read(searchTextProvider.notifier).state = text;
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(Icons.search)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _controller.clear();
                ref.read(searchTextProvider.notifier).state = '';
              },
              icon: const Icon(Icons.clear),
            )
          ],
        ),
        body: data.when(
          data: (data) => SearchListWidget(list: data),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, s) => const Center(
            child: Text('Error'),
          ),
        ));
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

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          child: searchText(list[index]),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black12, width: 1))),
        );
      },
    );
  }
}
