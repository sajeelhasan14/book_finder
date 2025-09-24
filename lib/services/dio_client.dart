// lib/services/dio_client.dart
import 'package:book_finder/core/constant.dart';
import 'package:dio/dio.dart';


class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: ApiConstants.networkTimeoutSeconds),
      receiveTimeout: Duration(seconds: ApiConstants.networkTimeoutSeconds),
      headers: {
        "Accept": "application/json",
        "User-Agent": "BookFinder/1.0 (contact@example.com)",
      },
    ),
  );

  static Dio get dio => _dio;

  static Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      final resp = await _dio.get(url, queryParameters: queryParams);
      return resp;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("HTTP ${e.response?.statusCode}: ${e.response?.data}");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }
}
