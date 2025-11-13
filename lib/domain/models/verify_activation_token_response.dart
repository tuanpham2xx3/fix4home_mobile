import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_activation_token_response.freezed.dart';
part 'verify_activation_token_response.g.dart';

@freezed
class VerifyActivationTokenResponse with _$VerifyActivationTokenResponse {
  const factory VerifyActivationTokenResponse({
    required String email,
    required String action,
    required String userId,
    required String userStatus,
  }) = _VerifyActivationTokenResponse;

  factory VerifyActivationTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyActivationTokenResponseFromJson(json);
}

