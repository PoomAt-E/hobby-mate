import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hobby_mate/model/post.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

class CommunityService {
  static final CommunityService _communityService =
      CommunityService._internal();
  factory CommunityService() {
    return _communityService;
  }
  CommunityService._internal();

  final String? _baseUrl = dotenv.env['COMMUNITY_SERVER_URL'];

  Future<List<Post>> getPost() async {
    try {
      Map<String, dynamic> result =
          await DioClient().get('$_baseUrl/', {}, true);
      if (result['result'] == Result.success) {
        List<Post> posts = result['response']
            .map((json) => Post.fromJson(json))
            .cast<Post>()
            .toList();

        return posts;
      } else {
        throw Exception('Failed to getPost');
      }
    } catch (e) {
      throw Exception('Failed to getPost');
    }
  }

  Future<List<Post>> getPopularPost() async {
    try {
      Map<String, dynamic> result =
          await DioClient().get('$_baseUrl/', {}, true);
      if (result['result'] == Result.success) {
        List<Post> posts = result['response']
            .map((json) => Post.fromJson(json))
            .cast<Post>()
            .toList();

        return posts;
      } else {
        throw Exception('Failed to getPost');
      }
    } catch (e) {
      throw Exception('Failed to getPost');
    }
  }
}
