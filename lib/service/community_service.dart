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

  Future<List<Board>> getBoard() async {
    try {
      Map<String, dynamic> result =
          await DioClient().get('$_baseUrl/', {}, true);
      if (result['result'] == Result.success) {
        List<Board> boards = result['response']
            .map((json) => Board.fromJson(json))
            .cast<Board>()
            .toList();

        return boards;
      } else {
        throw Exception('Failed to getBoard');
      }
    } catch (e) {
      throw Exception('Failed to getBoard');
    }
  }

  Future<List<Board>> getPopularBoard() async {
    try {
      Map<String, dynamic> result =
          await DioClient().get('$_baseUrl/', {}, true);
      if (result['result'] == Result.success) {
        List<Board> boards = result['response']
            .map((json) => Board.fromJson(json))
            .cast<Board>()
            .toList();

        return boards;
      } else {
        throw Exception('Failed to getBoard');
      }
    } catch (e) {
      throw Exception('Failed to getBoard');
    }
  }
}
