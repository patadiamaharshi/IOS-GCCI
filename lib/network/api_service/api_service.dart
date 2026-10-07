import 'package:dio/dio.dart';
import '../api_helper.dart';
import 'core_api_service.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  final Dio _dio = CoreApiService.instance.dio;

  Future<ApiResponse<T>> post<T>(
      // context,
      String endpoint, {
        dynamic body,
        T Function(dynamic data)? fromJson,
      }) {
    return ApiHelperLead.request(
      // context,
          () async => _dio.post(endpoint, data: body),
          (data) => fromJson != null ? fromJson(data) : data as T,
    );
  }

  Future<ApiResponse<T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        T Function(dynamic data)? fromJson,
      }) {
    return ApiHelperLead.request(
          () async => _dio.get(
        endpoint,
        queryParameters: queryParameters?.isNotEmpty == true ? queryParameters : null,
      ),
          (data) => fromJson != null ? fromJson(data) : data as T,
    );
  }
}