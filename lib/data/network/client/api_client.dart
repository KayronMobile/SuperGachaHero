import 'package:dio/dio.dart';

import '../../../domain/exception/network_exception.dart';
import '../entity/http_paged_result.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({
  required String baseUrl,
}) {
  _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  )
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
}

  Future<HttpPagedResult> getAgentes({
    required int page,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/agentes',
      queryParameters: {
        '_page': page,
        '_per_page': limit,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    }

    if (response.statusCode != null) {
      final data = Map<String, dynamic>.from(
        response.data,
      );

      return HttpPagedResult.fromJson(data);
    }

    throw Exception(
      'Erro desconhecido ao buscar agentes',
    );
  }
}