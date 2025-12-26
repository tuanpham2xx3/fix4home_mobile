import 'package:dio/dio.dart';
import '../../domain/models/notification_dto.dart';
import '../../domain/models/page.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/config/api_config.dart';

class ApiNotificationRepository implements NotificationRepository {
  final Dio _dio;

  ApiNotificationRepository(this._dio);

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

  T _parseResponseData<T>(Map<String, dynamic> responseData) {
    if (responseData['success'] != true) {
      final message = responseData['message'] ?? 'Request failed';
      throw Exception(message);
    }

    return responseData['data'] as T;
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
        case 401:
          return Exception('Không có quyền truy cập. Vui lòng đăng nhập lại');
        case 403:
          return Exception('Bạn không có quyền thực hiện hành động này');
        case 404:
          return Exception('Không tìm thấy thông báo');
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
  Future<Page<NotificationDTO>> getMyNotifications({
    int page = 0,
    int size = 20,
    String? sortBy,
    String? sortDir,
    bool? isRead,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (sortBy != null) {
        queryParameters['sortBy'] = sortBy;
      }
      if (sortDir != null) {
        queryParameters['sortDir'] = sortDir;
      }
      if (isRead != null) {
        queryParameters['isRead'] = isRead.toString();
      }

      final response = await _dio.get(
        ApiConfig.notificationsMyEndpoint,
        queryParameters: queryParameters,
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return Page.fromJson(
        data,
        (json) => NotificationDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy danh sách thông báo thất bại: ${e.toString()}');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(
        ApiConfig.notificationsUnreadCountEndpoint,
      );

      final responseData = response.data as Map<String, dynamic>;
      return _parseResponseData<int>(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy số lượng thông báo chưa đọc thất bại: ${e.toString()}');
    }
  }

  @override
  Future<NotificationDTO> getNotificationById(int notificationId) async {
    try {
      final response = await _dio.get(
        ApiConfig.notificationByIdEndpoint(notificationId),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return NotificationDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy chi tiết thông báo thất bại: ${e.toString()}');
    }
  }

  @override
  Future<NotificationDTO> markAsRead(int notificationId) async {
    try {
      final response = await _dio.put(
        ApiConfig.notificationMarkReadEndpoint(notificationId),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return NotificationDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đánh dấu thông báo đã đọc thất bại: ${e.toString()}');
    }
  }

  @override
  Future<int> markAllAsRead() async {
    try {
      final response = await _dio.put(
        ApiConfig.notificationsMarkAllReadEndpoint,
      );

      final responseData = response.data as Map<String, dynamic>;
      return _parseResponseData<int>(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đánh dấu tất cả thông báo đã đọc thất bại: ${e.toString()}');
    }
  }

  @override
  Future<int> markNotifications({
    required bool isRead,
    int? notificationId,
    List<int>? notificationIds,
    bool? markAll,
  }) async {
    try {
      final requestBody = <String, dynamic>{
        'isRead': isRead,
      };

      if (notificationId != null) {
        requestBody['notificationId'] = notificationId;
      } else if (notificationIds != null) {
        requestBody['notificationIds'] = notificationIds;
      } else if (markAll == true) {
        requestBody['markAll'] = true;
      }

      final response = await _dio.put(
        ApiConfig.notificationsMarkEndpoint,
        data: requestBody,
      );

      final responseData = response.data as Map<String, dynamic>;
      return _parseResponseData<int>(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đánh dấu thông báo thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _dio.delete(
        ApiConfig.notificationDeleteEndpoint(notificationId),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Xóa thông báo thất bại: ${e.toString()}');
    }
  }

  @override
  Future<int> deleteReadNotifications() async {
    try {
      final response = await _dio.delete(
        ApiConfig.notificationsDeleteReadEndpoint,
      );

      final responseData = response.data as Map<String, dynamic>;
      return _parseResponseData<int>(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Xóa thông báo đã đọc thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Page<NotificationDTO>> searchNotifications({
    required String keyword,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.notificationsSearchEndpoint,
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'size': size,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return Page.fromJson(
        data,
        (json) => NotificationDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Tìm kiếm thông báo thất bại: ${e.toString()}');
    }
  }

  @override
  Future<List<NotificationDTO>> getRecentNotifications({int days = 7}) async {
    try {
      final response = await _dio.get(
        ApiConfig.notificationsRecentEndpoint,
        queryParameters: {
          'days': days,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponseData<List<dynamic>>(responseData);
      return data
          .map((json) => NotificationDTO.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy thông báo gần đây thất bại: ${e.toString()}');
    }
  }
}

