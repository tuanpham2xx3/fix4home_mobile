import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_verification_email_request.freezed.dart';
part 'send_verification_email_request.g.dart';

@freezed
class SendVerificationEmailRequest with _$SendVerificationEmailRequest {
  const factory SendVerificationEmailRequest({
    required String email,
  }) = _SendVerificationEmailRequest;

  factory SendVerificationEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$SendVerificationEmailRequestFromJson(json);
}

