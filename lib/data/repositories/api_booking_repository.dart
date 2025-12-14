import 'package:dio/dio.dart';
import '../../domain/models/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../core/config/api_config.dart';

class ApiBookingRepository implements BookingRepository {
  final Dio _dio;

  ApiBookingRepository(this._dio);

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

  // Helper method to convert API booking data to Booking model
  Booking _bookingFromApiData(Map<String, dynamic> data) {
    return Booking.fromJson(data);
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
          return Exception('Không tìm thấy booking');
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
  Future<Booking> createBooking(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        ApiConfig.bookingsEndpoint,
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      final bookingData = _parseResponse(responseData);
      return _bookingFromApiData(bookingData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Tạo booking thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getBookings({
    String? status,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status.toUpperCase();
      }

      final response = await _dio.get(
        ApiConfig.bookingsEndpoint,
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      // Parse bookings list
      final bookingsList = (data['bookings'] as List<dynamic>)
          .map((item) => _bookingFromApiData(item as Map<String, dynamic>))
          .toList();

      return {
        'bookings': bookingsList,
        'total': data['total'] as int,
        'page': data['page'] as int,
        'limit': data['limit'] as int,
      };
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy danh sách booking thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Booking> getBookingById(int id) async {
    try {
      final response = await _dio.get(
        ApiConfig.bookingByIdEndpoint(id),
      );

      final responseData = response.data as Map<String, dynamic>;
      final bookingData = _parseResponse(responseData);
      return _bookingFromApiData(bookingData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy chi tiết booking thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Booking> updateBooking(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        ApiConfig.bookingByIdEndpoint(id),
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      final bookingData = _parseResponse(responseData);
      return _bookingFromApiData(bookingData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Cập nhật booking thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Booking> cancelBooking(int id) async {
    try {
      final response = await _dio.post(
        ApiConfig.cancelBookingEndpoint(id),
      );

      final responseData = response.data as Map<String, dynamic>;
      final bookingData = _parseResponse(responseData);
      return _bookingFromApiData(bookingData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Hủy booking thất bại: ${e.toString()}');
    }
  }
}

