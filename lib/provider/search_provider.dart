import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/member.dart';
import 'package:hobby_mate/service/member_service.dart';

import '../service/search_service.dart';

class SearchProvider extends StateNotifier<List<Member>>{
  SearchProvider() : super([]);
  final SearchService searchService = SearchService();

  @override
  set state(List<Member> value) {
    super.state = value;
  }

  Future search(String text) async {
    if(text.isEmpty){
      return;
    }
    MemberService().getMemberForKeyword(text).then((value) {
      state = value;
      print(value);
    }).catchError((onError) {
    });

  }

}