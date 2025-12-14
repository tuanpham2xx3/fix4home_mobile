// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_activation_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckActivationStatusResponse _$CheckActivationStatusResponseFromJson(
    Map<String, dynamic> json) {
  return _CheckActivationStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckActivationStatusResponse {
  String get email => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get userStatus => throw _privateConstructorUsedError;
  bool get isActivated => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasActiveToken')
  bool? get hasActiveToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'tokenExpiresAt')
  String? get tokenExpiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'canResend')
  bool? get canResend => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastSentAt')
  String? get lastSentAt => throw _privateConstructorUsedError;

  /// Serializes this CheckActivationStatusResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckActivationStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckActivationStatusResponseCopyWith<CheckActivationStatusResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckActivationStatusResponseCopyWith<$Res> {
  factory $CheckActivationStatusResponseCopyWith(
          CheckActivationStatusResponse value,
          $Res Function(CheckActivationStatusResponse) then) =
      _$CheckActivationStatusResponseCopyWithImpl<$Res,
          CheckActivationStatusResponse>;
  @useResult
  $Res call(
      {String email,
      int userId,
      String userStatus,
      bool isActivated,
      @JsonKey(name: 'hasActiveToken') bool? hasActiveToken,
      @JsonKey(name: 'tokenExpiresAt') String? tokenExpiresAt,
      @JsonKey(name: 'canResend') bool? canResend,
      @JsonKey(name: 'lastSentAt') String? lastSentAt});
}

/// @nodoc
class _$CheckActivationStatusResponseCopyWithImpl<$Res,
        $Val extends CheckActivationStatusResponse>
    implements $CheckActivationStatusResponseCopyWith<$Res> {
  _$CheckActivationStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckActivationStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? userId = null,
    Object? userStatus = null,
    Object? isActivated = null,
    Object? hasActiveToken = freezed,
    Object? tokenExpiresAt = freezed,
    Object? canResend = freezed,
    Object? lastSentAt = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      userStatus: null == userStatus
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isActivated: null == isActivated
          ? _value.isActivated
          : isActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      hasActiveToken: freezed == hasActiveToken
          ? _value.hasActiveToken
          : hasActiveToken // ignore: cast_nullable_to_non_nullable
              as bool?,
      tokenExpiresAt: freezed == tokenExpiresAt
          ? _value.tokenExpiresAt
          : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      canResend: freezed == canResend
          ? _value.canResend
          : canResend // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastSentAt: freezed == lastSentAt
          ? _value.lastSentAt
          : lastSentAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckActivationStatusResponseImplCopyWith<$Res>
    implements $CheckActivationStatusResponseCopyWith<$Res> {
  factory _$$CheckActivationStatusResponseImplCopyWith(
          _$CheckActivationStatusResponseImpl value,
          $Res Function(_$CheckActivationStatusResponseImpl) then) =
      __$$CheckActivationStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      int userId,
      String userStatus,
      bool isActivated,
      @JsonKey(name: 'hasActiveToken') bool? hasActiveToken,
      @JsonKey(name: 'tokenExpiresAt') String? tokenExpiresAt,
      @JsonKey(name: 'canResend') bool? canResend,
      @JsonKey(name: 'lastSentAt') String? lastSentAt});
}

/// @nodoc
class __$$CheckActivationStatusResponseImplCopyWithImpl<$Res>
    extends _$CheckActivationStatusResponseCopyWithImpl<$Res,
        _$CheckActivationStatusResponseImpl>
    implements _$$CheckActivationStatusResponseImplCopyWith<$Res> {
  __$$CheckActivationStatusResponseImplCopyWithImpl(
      _$CheckActivationStatusResponseImpl _value,
      $Res Function(_$CheckActivationStatusResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckActivationStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? userId = null,
    Object? userStatus = null,
    Object? isActivated = null,
    Object? hasActiveToken = freezed,
    Object? tokenExpiresAt = freezed,
    Object? canResend = freezed,
    Object? lastSentAt = freezed,
  }) {
    return _then(_$CheckActivationStatusResponseImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      userStatus: null == userStatus
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isActivated: null == isActivated
          ? _value.isActivated
          : isActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      hasActiveToken: freezed == hasActiveToken
          ? _value.hasActiveToken
          : hasActiveToken // ignore: cast_nullable_to_non_nullable
              as bool?,
      tokenExpiresAt: freezed == tokenExpiresAt
          ? _value.tokenExpiresAt
          : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      canResend: freezed == canResend
          ? _value.canResend
          : canResend // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastSentAt: freezed == lastSentAt
          ? _value.lastSentAt
          : lastSentAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckActivationStatusResponseImpl
    implements _CheckActivationStatusResponse {
  const _$CheckActivationStatusResponseImpl(
      {required this.email,
      required this.userId,
      required this.userStatus,
      required this.isActivated,
      @JsonKey(name: 'hasActiveToken') this.hasActiveToken,
      @JsonKey(name: 'tokenExpiresAt') this.tokenExpiresAt,
      @JsonKey(name: 'canResend') this.canResend,
      @JsonKey(name: 'lastSentAt') this.lastSentAt});

  factory _$CheckActivationStatusResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CheckActivationStatusResponseImplFromJson(json);

  @override
  final String email;
  @override
  final int userId;
  @override
  final String userStatus;
  @override
  final bool isActivated;
  @override
  @JsonKey(name: 'hasActiveToken')
  final bool? hasActiveToken;
  @override
  @JsonKey(name: 'tokenExpiresAt')
  final String? tokenExpiresAt;
  @override
  @JsonKey(name: 'canResend')
  final bool? canResend;
  @override
  @JsonKey(name: 'lastSentAt')
  final String? lastSentAt;

  @override
  String toString() {
    return 'CheckActivationStatusResponse(email: $email, userId: $userId, userStatus: $userStatus, isActivated: $isActivated, hasActiveToken: $hasActiveToken, tokenExpiresAt: $tokenExpiresAt, canResend: $canResend, lastSentAt: $lastSentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckActivationStatusResponseImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus) &&
            (identical(other.isActivated, isActivated) ||
                other.isActivated == isActivated) &&
            (identical(other.hasActiveToken, hasActiveToken) ||
                other.hasActiveToken == hasActiveToken) &&
            (identical(other.tokenExpiresAt, tokenExpiresAt) ||
                other.tokenExpiresAt == tokenExpiresAt) &&
            (identical(other.canResend, canResend) ||
                other.canResend == canResend) &&
            (identical(other.lastSentAt, lastSentAt) ||
                other.lastSentAt == lastSentAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, userId, userStatus,
      isActivated, hasActiveToken, tokenExpiresAt, canResend, lastSentAt);

  /// Create a copy of CheckActivationStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckActivationStatusResponseImplCopyWith<
          _$CheckActivationStatusResponseImpl>
      get copyWith => __$$CheckActivationStatusResponseImplCopyWithImpl<
          _$CheckActivationStatusResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckActivationStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _CheckActivationStatusResponse
    implements CheckActivationStatusResponse {
  const factory _CheckActivationStatusResponse(
          {required final String email,
          required final int userId,
          required final String userStatus,
          required final bool isActivated,
          @JsonKey(name: 'hasActiveToken') final bool? hasActiveToken,
          @JsonKey(name: 'tokenExpiresAt') final String? tokenExpiresAt,
          @JsonKey(name: 'canResend') final bool? canResend,
          @JsonKey(name: 'lastSentAt') final String? lastSentAt}) =
      _$CheckActivationStatusResponseImpl;

  factory _CheckActivationStatusResponse.fromJson(Map<String, dynamic> json) =
      _$CheckActivationStatusResponseImpl.fromJson;

  @override
  String get email;
  @override
  int get userId;
  @override
  String get userStatus;
  @override
  bool get isActivated;
  @override
  @JsonKey(name: 'hasActiveToken')
  bool? get hasActiveToken;
  @override
  @JsonKey(name: 'tokenExpiresAt')
  String? get tokenExpiresAt;
  @override
  @JsonKey(name: 'canResend')
  bool? get canResend;
  @override
  @JsonKey(name: 'lastSentAt')
  String? get lastSentAt;

  /// Create a copy of CheckActivationStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckActivationStatusResponseImplCopyWith<
          _$CheckActivationStatusResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
