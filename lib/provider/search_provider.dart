import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/search_service.dart';

class SearchProvider extends StateNotifier<List<String>>{
  SearchProvider() : super([]);
  final SearchService searchService = SearchService();

  @override
  set state(List<String> value) {
    super.state = value;
  }

  Future search(String text) async {
    if(text.isEmpty){
      return;
    }
    searchService.search(text).then((value) {
      state = value;
    }).catchError((onError) {
    });
  }

}