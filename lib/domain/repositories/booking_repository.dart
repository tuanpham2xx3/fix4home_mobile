import '../../domain/models/booking.dart';

abstract class BookingRepository {
  /// Create a new booking
  /// Returns the created booking with ID from server
  Future<Booking> createBooking(Map<String, dynamic> data);

  /// Get list of bookings with pagination and optional status filter
  /// Returns a map with 'bookings' (List<Booking>), 'total' (int), 'page' (int), 'limit' (int)
  Future<Map<String, dynamic>> getBookings({
    String? status,
    int page = 0,
    int limit = 10,
  });

  /// Get booking by ID
  Future<Booking> getBookingById(int id);

  /// Update an existing booking (only PENDING bookings can be updated)
  Future<Booking> updateBooking(int id, Map<String, dynamic> data);

  /// Cancel a booking (only PENDING bookings can be cancelled)
  Future<Booking> cancelBooking(int id);
}

