// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_activation_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerifyActivationTokenResponseImpl
    _$$VerifyActivationTokenResponseImplFromJson(Map<String, dynamic> json) =>
        _$VerifyActivationTokenResponseImpl(
          email: json['email'] as String,
          action: json['action'] as String,
          userId: json['userId'] as String,
          userStatus: json['userStatus'] as String,
        );

Map<String, dynamic> _$$VerifyActivationTokenResponseImplToJson(
        _$VerifyActivationTokenResponseImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'action': instance.action,
      'userId': instance.userId,
      'userStatus': instance.userStatus,
    };
