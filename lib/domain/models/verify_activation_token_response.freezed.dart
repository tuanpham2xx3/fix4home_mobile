// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_activation_token_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyActivationTokenResponse _$VerifyActivationTokenResponseFromJson(
    Map<String, dynamic> json) {
  return _VerifyActivationTokenResponse.fromJson(json);
}

/// @nodoc
mixin _$VerifyActivationTokenResponse {
  String get email => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userStatus => throw _privateConstructorUsedError;

  /// Serializes this VerifyActivationTokenResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyActivationTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyActivationTokenResponseCopyWith<VerifyActivationTokenResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyActivationTokenResponseCopyWith<$Res> {
  factory $VerifyActivationTokenResponseCopyWith(
          VerifyActivationTokenResponse value,
          $Res Function(VerifyActivationTokenResponse) then) =
      _$VerifyActivationTokenResponseCopyWithImpl<$Res,
          VerifyActivationTokenResponse>;
  @useResult
  $Res call({String email, String action, String userId, String userStatus});
}

/// @nodoc
class _$VerifyActivationTokenResponseCopyWithImpl<$Res,
        $Val extends VerifyActivationTokenResponse>
    implements $VerifyActivationTokenResponseCopyWith<$Res> {
  _$VerifyActivationTokenResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyActivationTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? action = null,
    Object? userId = null,
    Object? userStatus = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userStatus: null == userStatus
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyActivationTokenResponseImplCopyWith<$Res>
    implements $VerifyActivationTokenResponseCopyWith<$Res> {
  factory _$$VerifyActivationTokenResponseImplCopyWith(
          _$VerifyActivationTokenResponseImpl value,
          $Res Function(_$VerifyActivationTokenResponseImpl) then) =
      __$$VerifyActivationTokenResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String action, String userId, String userStatus});
}

/// @nodoc
class __$$VerifyActivationTokenResponseImplCopyWithImpl<$Res>
    extends _$VerifyActivationTokenResponseCopyWithImpl<$Res,
        _$VerifyActivationTokenResponseImpl>
    implements _$$VerifyActivationTokenResponseImplCopyWith<$Res> {
  __$$VerifyActivationTokenResponseImplCopyWithImpl(
      _$VerifyActivationTokenResponseImpl _value,
      $Res Function(_$VerifyActivationTokenResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyActivationTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? action = null,
    Object? userId = null,
    Object? userStatus = null,
  }) {
    return _then(_$VerifyActivationTokenResponseImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userStatus: null == userStatus
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyActivationTokenResponseImpl
    implements _VerifyActivationTokenResponse {
  const _$VerifyActivationTokenResponseImpl(
      {required this.email,
      required this.action,
      required this.userId,
      required this.userStatus});

  factory _$VerifyActivationTokenResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$VerifyActivationTokenResponseImplFromJson(json);

  @override
  final String email;
  @override
  final String action;
  @override
  final String userId;
  @override
  final String userStatus;

  @override
  String toString() {
    return 'VerifyActivationTokenResponse(email: $email, action: $action, userId: $userId, userStatus: $userStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyActivationTokenResponseImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, action, userId, userStatus);

  /// Create a copy of VerifyActivationTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyActivationTokenResponseImplCopyWith<
          _$VerifyActivationTokenResponseImpl>
      get copyWith => __$$VerifyActivationTokenResponseImplCopyWithImpl<
          _$VerifyActivationTokenResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyActivationTokenResponseImplToJson(
      this,
    );
  }
}

abstract class _VerifyActivationTokenResponse
    implements VerifyActivationTokenResponse {
  const factory _VerifyActivationTokenResponse(
      {required final String email,
      required final String action,
      required final String userId,
      required final String userStatus}) = _$VerifyActivationTokenResponseImpl;

  factory _VerifyActivationTokenResponse.fromJson(Map<String, dynamic> json) =
      _$VerifyActivationTokenResponseImpl.fromJson;

  @override
  String get email;
  @override
  String get action;
  @override
  String get userId;
  @override
  String get userStatus;

  /// Create a copy of VerifyActivationTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyActivationTokenResponseImplCopyWith<
          _$VerifyActivationTokenResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
