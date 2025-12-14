import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_activation_status_response.freezed.dart';
part 'check_activation_status_response.g.dart';

@freezed
class CheckActivationStatusResponse with _$CheckActivationStatusResponse {
  const factory CheckActivationStatusResponse({
    required String email,
    required int userId,
    required String userStatus,
    required bool isActivated,
    @JsonKey(name: 'hasActiveToken') bool? hasActiveToken,
    @JsonKey(name: 'tokenExpiresAt') String? tokenExpiresAt,
    @JsonKey(name: 'canResend') bool? canResend,
    @JsonKey(name: 'lastSentAt') String? lastSentAt,
  }) = _CheckActivationStatusResponse;

  factory CheckActivationStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckActivationStatusResponseFromJson(json);
}

