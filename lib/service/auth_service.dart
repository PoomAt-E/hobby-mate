import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:hobby_mate/model/member.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';
import 'package:http/http.dart' as http;

const storage = fss.FlutterSecureStorage();

class AuthService {
  static final AuthService _authService = AuthService._internal();
  factory AuthService() {
    return _authService;
  }
  AuthService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<bool> isLogin() async {
    // 로그인 되어있는지 확인 (토큰 만료 여부 확인)
    String? acToken = await storage.read(key: 'accessToken');
    String? rfToken = await storage.read(key: 'refreshToken');
    try {
      if (acToken == null && rfToken == null) {
        return false;
      } else {
        Map<String, dynamic> result = await DioClient().post(
            '$_baseUrl/auth/validate/token',
            {
              'accessToken': acToken,
              'refreshToken': rfToken,
              'authority': 'ROLE_USER'
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
      Map<String, dynamic> result = await DioClient().post(
          '$_baseUrl/auth/signIn/member',
          {'email': email, 'password': password, 'authority': 'ROLE_USER'},
          false);
      if (result['result'] == Result.success) {
        // 받은 토큰 저장
        final token = result['response']['token'];
        storage.write(key: 'accessToken', value: token['accessToken']);
        storage.write(key: 'refreshToken', value: token['refreshToken']);
        getUser(email);
        return true;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  // Future<bool> signUp({ // 이미지 저장 x 회원가입
  //   required Map<String, dynamic> user,
  // }) async {
  //   try {
  //     print('user.toString() : ${user.toString()}');
  //     NetWorkResult result = await DioClient()
  //         .Signup_post('$_baseUrl/auth/signUp/member', user, false);
  //     if (result.result == Result.success) {
  //       User user = User.fromJson(result.response);
  //       user.savePreference(user);
  //       return true;
  //     } else {
  //       throw Exception('Failed to signUp');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to signUp');
  //   }
  // }

  Future signupWithloadImage({
    // 이미지 저장 o 회원가입
    required String path,
    required Map<String, String> member,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/signUp/member');
      final request = http.MultipartRequest('POST', url);
      // 파일 업로드를 위한 http.MultipartRequest 생성
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('multipartFile', path);
      request.headers.addAll(
          {"Content-Type": "multipart/form-data"}); // request에 header 추가

      // 이미지 파일을 http.MultipartFile로 변환하여 request에 추가
      request.files.add(multipartFile);
      request.fields.addAll(member); // request에 fields 추가

      var streamedResponse = await request.send();
      var result = await http.Response.fromStream(streamedResponse);
      if (result.statusCode == 200) {
        Member member = Member.fromJson(json.decode(result.body));
        member.savePreference(member);
        return true;
      } else {
        throw Exception('Failed to signUp');
      }
    } catch (e) {
      throw Exception('Failed to signUp');
    }
  }

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

  Future<Member> getUser(String email) async {
    try {
      Map<String, dynamic> result = await DioClient().get(
          '$_baseUrl/member/get/email/$email', {'user_email': email}, true);
      if (result['result'] == Result.success) {
        Member member = Member.fromJson(result['response']);
        member.savePreference(member);
        return member;
      } else {
        throw Exception('Failed to getUser');
      }
    } catch (e) {
      throw Exception('Failed to getUser');
    }
  }
}
