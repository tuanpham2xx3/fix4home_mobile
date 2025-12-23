import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/news_article.dart';
import '../../core/config/api_config.dart';
import '../../core/services/api_client.dart';

class NewsService {
  final Dio _dio;

  NewsService({required Dio dio}) : _dio = dio;

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
        case 404:
          return Exception('Không tìm thấy bài viết');
        case 401:
          return Exception('Không có quyền truy cập');
        case 403:
          return Exception('Truy cập bị từ chối');
        default:
          return Exception(message);
      }
    } else {
      return Exception('Lỗi kết nối mạng. Vui lòng thử lại.');
    }
  }

  /// Get all published articles with pagination
  Future<ArticleListResponse> getAllNews({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.articlesEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ArticleListResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách bài viết: $e');
    }
  }

  /// Search articles with pagination
  Future<ArticleListResponse> searchNews(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    try {
      if (query.isEmpty) {
        return getAllNews(page: page, limit: limit);
      }

      final response = await _dio.get(
        ApiConfig.articlesSearchEndpoint,
        queryParameters: {
          'keyword': query,
          'page': page,
          'limit': limit,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ArticleListResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm bài viết: $e');
    }
  }

  /// Get article by ID
  Future<NewsArticle?> getNewsById(String id) async {
    try {
      final int articleId = int.parse(id);
      final response = await _dio.get(
        ApiConfig.articleByIdEndpoint(articleId),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return NewsArticle.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleDioError(e);
    } on FormatException {
      throw Exception('ID bài viết không hợp lệ');
    } catch (e) {
      throw Exception('Lỗi khi tải bài viết: $e');
    }
  }
}

// Provider for NewsService
final newsServiceProvider = Provider<NewsService>((ref) {
  final dio = ref.watch(dioProvider);
  return NewsService(dio: dio);
});
