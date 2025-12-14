import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/booking.dart';
import '../../../domain/repositories/booking_repository.dart';
import '../../../data/repositories/api_booking_repository.dart';
import '../../../core/services/api_client.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiBookingRepository(dio);
});

class BookingNotifier extends StateNotifier<AsyncValue<List<Booking>>> {
  final BookingRepository _repository;

  BookingNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      state = const AsyncValue.loading();
      final result = await _repository.getBookings();
      final bookings = result['bookings'] as List<Booking>;
      state = AsyncValue.data(bookings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addBooking(Map<String, dynamic> bookingData) async {
    try {
      // Show loading state
      final currentBookings = state.value ?? [];
      state = AsyncValue.data(currentBookings);

      // Create booking via API
      final newBooking = await _repository.createBooking(bookingData);

      // Update state with new booking at the beginning
      final updatedBookings = [newBooking, ...currentBookings];
      state = AsyncValue.data(updatedBookings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow; // Re-throw so UI can handle the error
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      // Cancel booking via API
      final cancelledBooking = await _repository.cancelBooking(bookingId);

      // Update state
      final currentBookings = state.value ?? [];
      final updatedBookings = currentBookings.map((booking) {
        if (booking.id == bookingId.toString()) {
          return cancelledBooking;
        }
        return booking;
      }).toList();
      state = AsyncValue.data(updatedBookings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> refreshBookings() async {
    await _loadBookings();
  }

  List<Booking> get pendingBookings {
    final bookings = state.value ?? [];
    return bookings.where((booking) => booking.status == BookingStatus.pending).toList();
  }

  List<Booking> get completedBookings {
    final bookings = state.value ?? [];
    return bookings.where((booking) => booking.status == BookingStatus.completed).toList();
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, AsyncValue<List<Booking>>>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingNotifier(repository);
});

