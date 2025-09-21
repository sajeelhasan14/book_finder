import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Accept": "application/json",
        "User-Agent": "BookFinder/1.0 (contact@example.com)", // change contact
      },
    ),
  );

  // Generic GET with error handling
  static Future<Response?> get(String url,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await dio.get(url, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("Error ${e.response?.statusCode}: ${e.response?.data}");
      } else {
        throw Exception("Network Error: ${e.message}");
      }
    }
  }
}
