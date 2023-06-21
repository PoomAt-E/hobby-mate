import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:hobby_mate/model/member.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

const storage = fss.FlutterSecureStorage();

class AuthService {
  static final AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  final String? _baseUrl = dotenv.env['AUTH_SERVER_URL'];

  Future<bool> isLogin() async {
    // 로그인 되어있는지 확인 (토큰 만료 여부 확인)
    String? acToken = await storage.read(key: 'accessToken');
    // String? rfToken = await storage.read(key: 'refreshToken');
    try {
      if (acToken == null) {
        return false;
      } else {
        Map<String, dynamic> result = await DioClient().post(
            '$_baseUrl/account/api/auth/validate',
            {
              'token': acToken,
            },
            false);
        if (result['result'] == Result.success) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    // 로그인
    try {
      final result = await Dio().post('$_baseUrl/account/api/auth/signin',
          data: {'email': email, 'password': password});
      if (result.statusCode == 200) {
        final member = await getMemberInfo(email);
        member.savePreference(member);
        return true;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future<bool> signUp(Map<String, dynamic> data) async {
    // 로그인
    try {
      Map<String, dynamic> result = await DioClient()
          .post('$_baseUrl/account/api/auth/signup', data, false);
      if (result['result'] == Result.success) {
        return true;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login $e');
    }
  }

  Future<Member> getMemberInfo(String email) async {
    try {
      Map<String, dynamic> result = await DioClient()
          .get('$_baseUrl/account/api/member/$email', {'email': email}, true);
      if (result['result'] == Result.success) {
        Member member = Member.fromJson(result['response']);
        return member;
      } else {
        throw Exception('Failed to getUser');
      }
    } catch (e) {
      throw Exception('Failed to getUser');
    }
  }
  Future<Member> getMyInfo() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      String? email = sharedPreferences.getString('email');
      Map<String, dynamic> result = await DioClient()
          .get('$_baseUrl/account/api/member/$email', {'email': email}, true);
      if (result['result'] == Result.success) {
        Member member = Member.fromJson(result['response']);
        return member;
      } else {
        throw Exception('Failed to getUser');
      }
    } catch (e) {
      throw Exception('Failed to getUser');
    }
  }

  // Future signupWithloadImage({
  //   // 이미지 저장 o 회원가입
  //   required String path,
  //   required Map<String, String> member,
  // }) async {
  //   try {
  //     final url = Uri.parse('$_baseUrl/auth/signUp/member');
  //     final request = http.MultipartRequest('POST', url);
  //     // 파일 업로드를 위한 http.MultipartRequest 생성
  //     http.MultipartFile multipartFile =
  //         await http.MultipartFile.fromPath('multipartFile', path);
  //     request.headers.addAll(
  //         {"Content-Type": "multipart/form-data"}); // request에 header 추가

  //     // 이미지 파일을 http.MultipartFile로 변환하여 request에 추가
  //     request.files.add(multipartFile);
  //     request.fields.addAll(member); // request에 fields 추가

  //     var streamedResponse = await request.send();
  //     var result = await http.Response.fromStream(streamedResponse);
  //     if (result.statusCode == 200) {
  //       Member member = Member.fromJson(json.decode(result.body));
  //       member.savePreference(member);
  //       return true;
  //     } else {
  //       throw Exception('Failed to signUp');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to signUp');
  //   }
  // }

  Future<bool> emailCheck(String email, String role) async {
    try {
      Map<String, dynamic> result = await DioClient().get(
          '$_baseUrl/auth/check/email/$email/role/$role',
          {'email': email, 'role': role},
          false);
      if (result['result'] == Result.success) {
        return result['response'];
      } else {
        throw Exception('Failed to emailCheck');
      }
    } catch (e) {
      throw Exception('Failed to emailCheck');
    }
  }
}
