import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:hobby_mate/service/token_service.dart';

import '../model/network_result.dart';

const storage = fss.FlutterSecureStorage();

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  String? _acToken;
  String? _refToken;
  final Dio _dio = Dio();

  DioClient._internal() {
    _getToken();
  }

  _getToken() async {
    _acToken = await storage.read(key: 'accessToken');
    _refToken = await storage.read(key: 'refreshToken');
  }

  Future<Map<String, dynamic>> get(
      String url, Map<String, dynamic>? parameter, bool useToken) async {
    try {
      _getToken();
      Response response = await _dio.get(url,
          queryParameters: parameter,
          options: useToken
              ? Options(
                  contentType: Headers.jsonContentType,
                  headers: {
                    HttpHeaders.authorizationHeader: 'Bearer $_acToken',
                    'RT':
                        _refToken, // 이거는 토큰이 만료되었을 때, 새로운 토큰을 받아오기 위해 필요한 헤더입니다.
                  },
                )
              : Options(contentType: Headers.jsonContentType));
      if (response.statusCode == 200) {
        return {'result': Result.success, 'response': response.data['data']};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        TokenService().refreshToken();
        return {'result': Result.tokenExpired};
      } else {
        return {'result': Result.fail};
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return {'result': Result.fail, 'response': e.response};
      } else {
        return {'result': Result.fail};
      }
    }
  }

  Future<Map<String, dynamic>> post(
      String url, dynamic data, bool useToken) async {
    try {
      _getToken();
      Response response = await _dio.post(url,
          data: json.encode(data),
          options: useToken
              ? Options(
                  contentType: Headers.jsonContentType,
                  headers: {
                    HttpHeaders.authorizationHeader: 'Bearer $_acToken',
                    'RT':
                        _refToken, // 이거는 토큰이 만료되었을 때, 새로운 토큰을 받아오기 위해 필요한 헤더입니다.
                  },
                )
              : Options(contentType: Headers.jsonContentType));
      if (response.statusCode == 200) {
        return {'result': Result.success, 'response': response.data['data']};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        TokenService().refreshToken();
        return {'result': Result.tokenExpired};
      } else {
        return {'result': Result.fail};
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return {'result': Result.fail, 'response': e.response};
      } else {
        return {'result': Result.fail};
      }
    }
  }

  // Future<Map<String, dynamic>> signUpPost(
  //     // 회원가입 전용(사진 전송위함)
  //     String url,
  //     dynamic data,
  //     bool useToken) async {
  //   try {
  //     _getToken();
  //     Response response = await _dio.post(url,
  //         data: data,
  //         options: useToken
  //             ? Options(
  //                 contentType: Headers.jsonContentType,
  //                 headers: {
  //                   HttpHeaders.authorizationHeader: 'Bearer $_acToken',
  //                   'RT':
  //                       _refToken, // 이거는 토큰이 만료되었을 때, 새로운 토큰을 받아오기 위해 필요한 헤더입니다.
  //                 },
  //               )
  //             : Options(contentType: "multipart/form-data"));
  //     if (response.statusCode == 200) {
  //       _checkToken(response.headers);
  //       return {'result': Result.success, 'response': response.data};
  //     } else if (response.statusCode == 401) {
  //       if (response.headers.value('CODE') == 'RTE') {
  //         // 토큰이 만료되었을 때
  //         return {'result': Result.tokenExpired};
  //       } else {
  //         return {'result': Result.fail};
  //       }
  //     } else {
  //       print("${response.realUri} [500] 서버에서 처리가 안됌");
  //       _checkToken(response.headers);
  //       return {'result': Result.fail};
  //     }
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       return {'result': Result.fail, 'response': e.response};
  //     } else {
  //       return {'result': Result.fail};
  //     }
  //   }
  // }
}
