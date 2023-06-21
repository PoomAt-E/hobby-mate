import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/vod.dart';

class SearchClassProvider extends StateNotifier<List<Vod>>{
  SearchClassProvider() : super([]);
  final SearchClassProvider searchService = SearchClassProvider();

  @override
  set state(List<Vod> value) {
    super.state = value;
  }

  Future search(String text) async {
    if(text.isEmpty){
      return;
    }
    // MemberService().getMemberForKeyword(text).then((value) {
    //   state = value;
    // }).catchError((onError) {
    // });

  }

}