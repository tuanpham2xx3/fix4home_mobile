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
  final String? wardCode;
  final bool needsSurvey;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.title,
    required this.address,
    required this.date,
    required this.status,
    this.notes,
    required this.phone,
    required this.name,
    this.wardCode,
    this.needsSurvey = false,
    this.createdAt,
    this.updatedAt,
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
      'wardCode': wardCode,
      'needsSurvey': needsSurvey,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert to API request JSON (for creating/updating bookings)
  Map<String, dynamic> toApiJson() {
    final json = <String, dynamic>{
      'title': title,
      'address': address,
      'date': date.toIso8601String().split('.')[0], // Remove milliseconds for API
      'phone': phone,
      'name': name,
    };
    
    if (notes != null && notes!.isNotEmpty) {
      json['notes'] = notes;
    }
    
    if (wardCode != null && wardCode!.isNotEmpty) {
      json['wardCode'] = wardCode;
    }
    
    if (needsSurvey) {
      json['needsSurvey'] = needsSurvey;
    }
    
    return json;
  }

  // Create from JSON (handles both local storage and API response)
  factory Booking.fromJson(Map<String, dynamic> json) {
    // Handle both String and int IDs (API returns int, local storage uses String)
    final idValue = json['id'];
    final id = idValue is int ? idValue.toString() : idValue as String;
    
    // Parse status - API returns uppercase (PENDING, COMPLETED, CANCELLED)
    final statusStr = json['status'] as String;
    final status = BookingStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == statusStr.toUpperCase(),
      orElse: () => BookingStatus.pending,
    );
    
    // Parse dates
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        return DateTime.parse(value);
      }
      return null;
    }
    
    return Booking(
      id: id,
      title: json['title'] as String,
      address: json['address'] as String,
      date: DateTime.parse(json['date'] as String),
      status: status,
      notes: json['notes'] as String?,
      phone: json['phone'] as String,
      name: json['name'] as String,
      wardCode: json['wardCode'] as String?,
      needsSurvey: json['needsSurvey'] as bool? ?? false,
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }
}

enum BookingStatus {
  pending,
  completed,
  cancelled,
}

