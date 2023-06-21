import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hobby_mate/network/dio_client.dart';

import '../model/member.dart';
import '../model/network_result.dart';

class MemberService {
  final String? _baseUrl = dotenv.env['AUTH_SERVER_URL'];

  Future<List<Member>> getRecommendMember() async {
    try {
      Map<String, dynamic> result =
          await DioClient().get('$_baseUrl/account/api/member/list', {}, false);
      if (result['result'] == Result.success) {
        List<Member> members = result['response']
            .map((json) => Member.fromJson(json))
            .cast<Member>()
            .toList();

        return members;
      } else {
        throw Exception('Failed to get');
      }
    } catch (e) {
      throw Exception('Failed to get');
    }
  }

  Future<List<Member>> getMemberForKeyword(String major) async {
    try {
      Map<String, dynamic> result = await DioClient().get(
          '$_baseUrl/account/api/member/list/major', {'major': major}, false);
      if (result['result'] == Result.success) {
        List<Member> members = result['response']
            .map((json) => Member.fromJson(json))
            .cast<Member>()
            .toList();
        print(members);

        return members;
      } else {
        throw Exception('Failed to get');
      }
    } catch (e) {
      throw Exception('Failed to get');
    }
  }
}
