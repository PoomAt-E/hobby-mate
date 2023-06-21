import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

class SearchService {
  static final SearchService _searchService = SearchService._internal();
  factory SearchService() {
    return _searchService;
  }
  SearchService._internal();
  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<List<String>> search(String key) async {
    try {
      Map<String, dynamic> result =
          await DioClient().get('$_baseUrl/', {'keyword': key}, true);
      if (result['result'] == Result.success) {
        // List<String> results = result['response']
        //     .map((json) => Board.fromJson(json))
        //     .cast<Board>()
        //     .toList();
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return ['어쩌구', '저쩌구', '어쩌구'];
      throw Exception('Failed to getBoard');
    }
  }
}
