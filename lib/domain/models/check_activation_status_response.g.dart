// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_activation_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckActivationStatusResponseImpl
    _$$CheckActivationStatusResponseImplFromJson(Map<String, dynamic> json) =>
        _$CheckActivationStatusResponseImpl(
          email: json['email'] as String,
          userId: (json['userId'] as num).toInt(),
          userStatus: json['userStatus'] as String,
          isActivated: json['isActivated'] as bool,
          hasActiveToken: json['hasActiveToken'] as bool?,
          tokenExpiresAt: json['tokenExpiresAt'] as String?,
          canResend: json['canResend'] as bool?,
          lastSentAt: json['lastSentAt'] as String?,
        );

Map<String, dynamic> _$$CheckActivationStatusResponseImplToJson(
        _$CheckActivationStatusResponseImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'userId': instance.userId,
      'userStatus': instance.userStatus,
      'isActivated': instance.isActivated,
      'hasActiveToken': instance.hasActiveToken,
      'tokenExpiresAt': instance.tokenExpiresAt,
      'canResend': instance.canResend,
      'lastSentAt': instance.lastSentAt,
    };
