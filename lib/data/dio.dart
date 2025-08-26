import 'package:dio/dio.dart';
import 'package:middle_tth_assignment/constants.dart';
import 'package:middle_tth_assignment/data/models.dart';
import 'package:middle_tth_assignment/main.dart';

class DioService {
  factory DioService() {
    return _instance;
  }
  DioService._privateConstructor();

  static final DioService _instance = DioService._privateConstructor();

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> get(String endpoint, Map<String, dynamic> queryMap) async {
    try {
      queryMap[ApiConstants.apiKey] = ApiConstants.apiKeyValue;
      final query =
          '?${queryMap.entries.map((entry) {
            return '${entry.key}=${entry.value}';
          }).join('&')}';
      final response = await _dio.get('${ApiConstants.api}$endpoint$query');
      return response.data;
    } catch (error, stack) {
      logger.e('''
         Error in DioService.get: 
         Error: $error,
         Stack: $stack,
         Parameters:
            endpoint: $endpoint,
            query parameters: $queryMap
         Response: $Response''');
      rethrow;
    }
  }
}

class ApiService {
  Future<List<AssetResponse>> getAssets({int page = 1}) async {
    final response = await DioService().get(ApiConstants.assets, {
      'limit': RequestParametersHelper.limit,
      'offset': RequestParametersHelper.getOffset(page),
    });
    final data = response['data'] as List;
    return data.map((d) => AssetResponse.fromMap(d)).toList();
  }
}

class RequestParametersHelper {
  static const int limit = 15;
  static int getOffset(int page) {
    return (page - 1) * limit;
  }
}
