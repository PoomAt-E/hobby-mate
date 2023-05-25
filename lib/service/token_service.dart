import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

class TokenService {
  static final TokenService _TokenService = TokenService._internal();
  factory TokenService() {
    return _TokenService;
  }
  TokenService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<bool> validateToken() async {
    String? token = await storage.read(key: 'accessToken');
    try {
      if (token == null) {
        return false;
      } else {
        Map<String, dynamic> result = await DioClient().post(
            '$_baseUrl/account/api/auth/validate',
            {
              'token': token,
            },
            false);
        if (result['result'] == Result.success) {
          return true;
        } else if (result['result'] == Result.tokenExpired) {
          refreshToken();
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshToken() async {
    try {
      String? token = await storage.read(key: 'accessToken');
      String? refToken = await storage.read(key: 'refreshToken');
      Map<String, dynamic> result = await DioClient().post(
          '$_baseUrl/account/api/auth/refresh',
          {'accessToken': token, 'refreshToken': refToken},
          false);
      if (result['result'] == Result.success) {
        String acToken = result['response']['accessToken'];
        String refToken = result['response']['refreshToken'];

        storage.write(key: 'accessToken', value: acToken);
        storage.write(key: 'refresh', value: refToken);
      }
    } catch (e) {}
  }
}
