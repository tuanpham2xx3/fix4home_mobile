import 'dart:convert';

class Booking {
  final String id;
  final String title;
  final String address;
  final DateTime date;
  final BookingStatus status;
  final String? notes;
  final String phone;
  final String name;

  Booking({
    required this.id,
    required this.title,
    required this.address,
    required this.date,
    required this.status,
    this.notes,
    required this.phone,
    required this.name,
  });

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Đang chờ';
      case BookingStatus.completed:
        return 'Đã làm';
      case BookingStatus.cancelled:
        return 'Đã hủy';
    }
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'date': date.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'phone': phone,
      'name': name,
    };
  }

  // Create from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      title: json['title'] as String,
      address: json['address'] as String,
      date: DateTime.parse(json['date'] as String),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'] as String?,
      phone: json['phone'] as String,
      name: json['name'] as String,
    );
  }
}

enum BookingStatus {
  pending,
  completed,
  cancelled,
}

