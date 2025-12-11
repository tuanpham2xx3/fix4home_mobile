import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/booking.dart';

class BookingStorageService {
  static const String _bookingsKey = 'bookings';

  Future<void> saveBookings(List<Booking> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = bookings.map((booking) => booking.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_bookingsKey, jsonString);
  }

  Future<List<Booking>> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_bookingsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => Booking.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookingsKey);
  }
}

