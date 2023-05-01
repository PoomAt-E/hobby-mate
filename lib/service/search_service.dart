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
          await DioClient().get('$_baseUrl/', {}, true);
      if (result['result'] == Result.success) {
        // List<String> posts = result['response']
        //     .map((json) => Post.fromJson(json))
        //     .cast<Post>()
        //     .toList();

        return [];
      } else {
        return ['어쩌구', '저쩌구', '어쩌구'];
        throw Exception('Failed to getPost');
      }
    } catch (e) {
      return ['어쩌구', '저쩌구', '어쩌구'];
      throw Exception('Failed to getPost');
    }
  }
}
