import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hobby_mate/model/matching.dart';
import 'package:hobby_mate/model/post.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

class MatchService {
  static final MatchService _communityService =
  MatchService._internal();

  factory MatchService() {
    return _communityService;
  }

  MatchService._internal();

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

  Future<List<Matching>> getMatch() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final mentorEmail = pref.getString('email');
      final result = await Dio().get(
          '$_baseUrl/match/get/mentor/$mentorEmail',
          queryParameters: {'mentorId': mentorEmail});

      List<Matching> matches = result.data
          .map((json) => Matching.fromJson(json))
          .cast<Matching>()
          .toList();
      return matches;
    } catch (e) {
      throw Exception('Failed to getMatch: $e');
    }
  }


  Future<void> saveMatch(String email) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final menteeEmail = sharedPref.getString('email');
      final match = {'isMentor': false, 'matchDate': DateFormat('yyyy-MM-dd').format(DateTime.now()), 'mentorEmail': email, 'menteeEmail': menteeEmail};
      Map<String, dynamic> result = await DioClient()
          .post('$_baseUrl/match/save', match, false);
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

  Future<void> acceptMatch(String id)async{
    try{
      Map<String, dynamic> result =
      await DioClient().get('$_baseUrl/match/accept/match/$id', {'matchId': id}, false);
      if(result['result'] == Result.success) {
        print('success to acceptMatch');
      }else{
        throw Exception('Failed to acceptMatch');
      }
    }catch(e){
      throw Exception('Failed to acceptMatch');
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