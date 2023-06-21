import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hobby_mate/model/vod.dart';
import 'package:hobby_mate/network/dio_client.dart';

import '../model/network_result.dart';

class StreamingService {
  static final StreamingService _streamingService = StreamingService
      ._internal();

  factory StreamingService() {
    return _streamingService;
  }

  StreamingService._internal();

  final String? _baseUrl = dotenv.env['STREAMING_SERVER_URO'];

  Future<List<VodGroup>> getAllVodGroup() async {
    try {
      final result = await DioClient().get('$_baseUrl/streaming/api/vodGroup/List', {}, false);
      if(result['result'] == Result.success){
        List<VodGroup> vodGroups = result['response']
            .map((json) => VodGroup.fromJson(json))
            .cast<VodGroup>()
            .toList();
        return vodGroups;
      }else{
        throw Exception('Failed to get vodgroups');
      }
    } catch (e){
      throw Exception('Failed to get vodgroups: $e');
    }
  }

  Future<VodGroup> getVodDetail(String id)async{
    try {
      final result = await DioClient().get('$_baseUrl/streaming/api/vodGroup/list/detail/$id', {'vodGroupId': id}, false);
      if(result['result'] == Result.success){
       VodGroup vodGroup = VodGroup.fromJson(result['response']);
       print('vodGroup: ${vodGroup.id}');
        return vodGroup;
      }else{
        throw Exception('Failed to get vodgroups');
      }
    } catch (e){
      throw Exception('Failed to get vodgroups: $e');
    }
  }
  Future<List<VodGroup>> getVodForMentor(String id)async{
    try {
      final result = await DioClient().get('$_baseUrl/streaming/api/vodGroup/list/$id', {'mentorId': id}, false);
      if(result['result'] == Result.success){
        List<VodGroup> vodGroups = result['response']
            .map((json) => VodGroup.fromJson(json))
            .cast<VodGroup>()
            .toList();
        return vodGroups;
      }else{
        throw Exception('Failed to get vodgroups');
      }
    } catch (e){
      throw Exception('Failed to get vodgroups: $e');
    }
  }
}