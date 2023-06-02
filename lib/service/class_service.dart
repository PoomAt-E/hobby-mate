import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hobby_mate/model/Estimate.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

class ClassService{
  static final ClassService _authService = ClassService._internal();
  factory ClassService() {
    return _authService;
  }
  ClassService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future sendEstimate(Estimate estimate) async {
    try {
      Map<String, dynamic> result = await DioClient()
          .post('$_baseUrl/', estimate, true);
      if (result['result'] == Result.success) {
        return true;
      } else {
        throw Exception('Failed to send');
      }
    } catch (e) {
      throw Exception('Failed to send');
    }

  }

}