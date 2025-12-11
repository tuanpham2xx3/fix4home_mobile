import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/booking.dart';
import '../../../core/services/booking_storage_service.dart';

final bookingStorageServiceProvider = Provider<BookingStorageService>((ref) {
  return BookingStorageService();
});

class BookingNotifier extends StateNotifier<List<Booking>> {
  final BookingStorageService _storageService;

  BookingNotifier(this._storageService) : super([]) {
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final bookings = await _storageService.loadBookings();
    state = bookings;
  }

  Future<void> _saveBookings() async {
    await _storageService.saveBookings(state);
  }

  Future<void> addBooking(Booking booking) async {
    state = [booking, ...state];
    await _saveBookings();
  }

  Future<void> cancelBooking(String bookingId) async {
    state = state.map((booking) {
      if (booking.id == bookingId) {
        return Booking(
          id: booking.id,
          title: booking.title,
          address: booking.address,
          date: booking.date,
          status: BookingStatus.cancelled,
          notes: booking.notes,
          phone: booking.phone,
          name: booking.name,
        );
      }
      return booking;
    }).toList();
    await _saveBookings();
  }

  Future<void> completeBooking(String bookingId) async {
    state = state.map((booking) {
      if (booking.id == bookingId) {
        return Booking(
          id: booking.id,
          title: booking.title,
          address: booking.address,
          date: booking.date,
          status: BookingStatus.completed,
          notes: booking.notes,
          phone: booking.phone,
          name: booking.name,
        );
      }
      return booking;
    }).toList();
    await _saveBookings();
  }

  List<Booking> get pendingBookings {
    return state.where((booking) => booking.status == BookingStatus.pending).toList();
  }

  List<Booking> get completedBookings {
    return state.where((booking) => booking.status == BookingStatus.completed).toList();
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  final storageService = ref.watch(bookingStorageServiceProvider);
  return BookingNotifier(storageService);
});

