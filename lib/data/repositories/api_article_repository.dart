import 'package:dio/dio.dart';
import '../../domain/models/article_dto.dart';
import '../../domain/models/article_list_response.dart';
import '../../domain/repositories/article_repository.dart';
import '../../core/config/api_config.dart';

class ApiArticleRepository implements ArticleRepository {
  final Dio _dio;

  ApiArticleRepository(this._dio);

  // Helper method to parse API response with { success, message, data } structure
  Map<String, dynamic> _parseResponse(Map<String, dynamic> responseData) {
    if (responseData['success'] != true) {
      final message = responseData['message'] ?? 'Request failed';
      throw Exception(message);
    }

    if (responseData['data'] == null) {
      throw Exception('Response data is null');
    }

    return responseData['data'] as Map<String, dynamic>;
  }

  // Helper method to handle Dio errors
  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      String message = 'Đã xảy ra lỗi';

      if (data is Map<String, dynamic>) {
        message = data['userMessage'] ??
            data['message'] ??
            data['error'] ??
            data['errorMessage'] ??
            message;
      }

      switch (statusCode) {
        case 400:
          return Exception('Yêu cầu không hợp lệ: $message');
        case 404:
          return Exception('Không tìm thấy bài viết');
        case 422:
          return Exception('Dữ liệu không hợp lệ: $message');
        case 500:
        case 502:
        case 503:
          return Exception('Lỗi máy chủ. Vui lòng thử lại sau');
        default:
          return Exception('Lỗi $statusCode: $message');
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return Exception('Kết nối quá thời gian. Vui lòng kiểm tra kết nối mạng');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng');
    } else {
      return Exception('Đã xảy ra lỗi: ${error.message}');
    }
  }

  @override
  Future<ArticleListResponseDTO> getArticles({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.articlesEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit > 100 ? 100 : limit, // Max limit is 100
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ArticleListResponseDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy danh sách bài viết thất bại: ${e.toString()}');
    }
  }

  @override
  Future<ArticleDTO> getArticleById(int id) async {
    try {
      final response = await _dio.get(
        ApiConfig.articleByIdEndpoint(id),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ArticleDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy chi tiết bài viết thất bại: ${e.toString()}');
    }
  }

  @override
  Future<ArticleDTO> getArticleBySlug(String slug) async {
    try {
      final encodedSlug = Uri.encodeComponent(slug);
      final response = await _dio.get(
        ApiConfig.articleBySlugEndpoint(encodedSlug),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ArticleDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy chi tiết bài viết thất bại: ${e.toString()}');
    }
  }

  @override
  Future<ArticleListResponseDTO> searchArticles({
    String? keyword,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit > 100 ? 100 : limit, // Max limit is 100
      };

      if (keyword != null && keyword.trim().isNotEmpty) {
        queryParameters['keyword'] = keyword.trim();
      }

      final response = await _dio.get(
        ApiConfig.articlesSearchEndpoint,
        queryParameters: queryParameters,
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ArticleListResponseDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Tìm kiếm bài viết thất bại: ${e.toString()}');
    }
  }
}

