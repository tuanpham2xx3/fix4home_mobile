import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'token_storage_service.dart';

final deviceIdServiceProvider = Provider<DeviceIdService>((ref) {
  return DeviceIdService(
    ref.watch(flutterSecureStorageProvider),
    DeviceInfoPlugin(),
  );
});

class DeviceIdService {
  final FlutterSecureStorage _storage;
  final DeviceInfoPlugin _deviceInfo;
  static const _deviceIdKey = 'device_id';
  static const _uuid = Uuid();

  DeviceIdService(this._storage, this._deviceInfo);

  Future<String> getDeviceId() async {
    // Try to get existing device ID from storage
    final existingId = await _storage.read(key: _deviceIdKey);
    if (existingId != null && existingId.isNotEmpty) {
      return existingId;
    }

    // Generate new device ID
    String deviceId;
    try {
      if (kIsWeb) {
        // For web, use browser fingerprint or generate UUID
        deviceId = _uuid.v4();
      } else {
        // For mobile, try to use device-specific ID
        if (defaultTargetPlatform == TargetPlatform.android) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceId = androidInfo.id; // Android ID
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? _uuid.v4();
        } else {
          // Fallback to UUID for other platforms
          deviceId = _uuid.v4();
        }
      }

      // If device ID is empty or invalid, generate UUID
      if (deviceId.isEmpty) {
        deviceId = _uuid.v4();
      }
    } catch (e) {
      // If any error occurs, fallback to UUID
      deviceId = _uuid.v4();
    }

    // Save device ID to storage
    await _storage.write(key: _deviceIdKey, value: deviceId);
    return deviceId;
  }

  Future<void> clearDeviceId() async {
    await _storage.delete(key: _deviceIdKey);
  }
}

