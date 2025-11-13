// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_verification_email_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SendVerificationEmailRequest _$SendVerificationEmailRequestFromJson(
    Map<String, dynamic> json) {
  return _SendVerificationEmailRequest.fromJson(json);
}

/// @nodoc
mixin _$SendVerificationEmailRequest {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this SendVerificationEmailRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendVerificationEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendVerificationEmailRequestCopyWith<SendVerificationEmailRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendVerificationEmailRequestCopyWith<$Res> {
  factory $SendVerificationEmailRequestCopyWith(
          SendVerificationEmailRequest value,
          $Res Function(SendVerificationEmailRequest) then) =
      _$SendVerificationEmailRequestCopyWithImpl<$Res,
          SendVerificationEmailRequest>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$SendVerificationEmailRequestCopyWithImpl<$Res,
        $Val extends SendVerificationEmailRequest>
    implements $SendVerificationEmailRequestCopyWith<$Res> {
  _$SendVerificationEmailRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendVerificationEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendVerificationEmailRequestImplCopyWith<$Res>
    implements $SendVerificationEmailRequestCopyWith<$Res> {
  factory _$$SendVerificationEmailRequestImplCopyWith(
          _$SendVerificationEmailRequestImpl value,
          $Res Function(_$SendVerificationEmailRequestImpl) then) =
      __$$SendVerificationEmailRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$SendVerificationEmailRequestImplCopyWithImpl<$Res>
    extends _$SendVerificationEmailRequestCopyWithImpl<$Res,
        _$SendVerificationEmailRequestImpl>
    implements _$$SendVerificationEmailRequestImplCopyWith<$Res> {
  __$$SendVerificationEmailRequestImplCopyWithImpl(
      _$SendVerificationEmailRequestImpl _value,
      $Res Function(_$SendVerificationEmailRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendVerificationEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$SendVerificationEmailRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendVerificationEmailRequestImpl
    implements _SendVerificationEmailRequest {
  const _$SendVerificationEmailRequestImpl({required this.email});

  factory _$SendVerificationEmailRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SendVerificationEmailRequestImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'SendVerificationEmailRequest(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendVerificationEmailRequestImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of SendVerificationEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendVerificationEmailRequestImplCopyWith<
          _$SendVerificationEmailRequestImpl>
      get copyWith => __$$SendVerificationEmailRequestImplCopyWithImpl<
          _$SendVerificationEmailRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendVerificationEmailRequestImplToJson(
      this,
    );
  }
}

abstract class _SendVerificationEmailRequest
    implements SendVerificationEmailRequest {
  const factory _SendVerificationEmailRequest({required final String email}) =
      _$SendVerificationEmailRequestImpl;

  factory _SendVerificationEmailRequest.fromJson(Map<String, dynamic> json) =
      _$SendVerificationEmailRequestImpl.fromJson;

  @override
  String get email;

  /// Create a copy of SendVerificationEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendVerificationEmailRequestImplCopyWith<
          _$SendVerificationEmailRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
