import 'package:dio/dio.dart';
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
      // Map<String, dynamic> result =
      final result = await Dio().get('$_baseUrl/community/board');
      print(result);
      List<Board> boards = result.data
          .map((json) => Board.fromJson(json))
          .cast<Board>()
          .toList();
      return boards;
    } catch (e) {
      throw Exception('Failed to getBoard');
    }
  }

  Future<List<Comment>> getComments(String boardId) async {
    try {
      final result = await Dio().get(
          '$_baseUrl/community/board/get/comment/$boardId',
          queryParameters: {'boardId': boardId});

      List<Comment> comments = result.data
          .map((json) => Comment.fromJson(json))
          .cast<Comment>()
          .toList();
      return comments;
    } catch (e) {
      throw Exception('Failed to getComments');
    }
  }

  Future<void> saveBoard(Map<String, dynamic> board) async {
    try {
      Map<String, dynamic> result = await DioClient()
          .post('$_baseUrl/community/board/save', board, false);
      if (result['result'] == Result.success) {
        print('success to saveBoard');
      } else {
        throw Exception('Failed to saveBoard');
      }
    } catch (e) {
      throw Exception('Failed to saveBoard');
    }
  }

  Future<void> saveComments(Map<String, dynamic> comment) async {
    try {
      Map<String, dynamic> result = await DioClient()
          .post('$_baseUrl/community/comment/save', comment, false);
      if (result['result'] == Result.success) {
        print('success to saveBoard');
      } else {
        throw Exception('Failed to saveBoard');
      }
    } catch (e) {
      throw Exception('Failed to saveBoard');
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
