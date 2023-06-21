import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/vod.dart';
import 'package:hobby_mate/service/streaming_service.dart';

class SearchClassProvider extends StateNotifier<List<VodGroup>> {
  SearchClassProvider() : super([]);

  @override
  set state(List<VodGroup> value) {
    super.state = value;
  }

  Future search(String text) async {
    if (text.isEmpty) {
      return;
    }
    StreamingService().getVodForKeyword(text).then((value) {
      state = value;
    }).catchError((onError) {});
  }
}
