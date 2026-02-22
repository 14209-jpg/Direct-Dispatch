// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceRequest _$ServiceRequestFromJson(Map<String, dynamic> json) {
  return _ServiceRequest.fromJson(json);
}

/// @nodoc
mixin _$ServiceRequest {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get serviceType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get conversationId =>
      throw _privateConstructorUsedError; // Admin fills these after speaking with customer
  String? get adminNotes => throw _privateConstructorUsedError;
  int? get numberOfWorkers => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ServiceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceRequestCopyWith<ServiceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceRequestCopyWith<$Res> {
  factory $ServiceRequestCopyWith(
    ServiceRequest value,
    $Res Function(ServiceRequest) then,
  ) = _$ServiceRequestCopyWithImpl<$Res, ServiceRequest>;
  @useResult
  $Res call({
    String id,
    String customerId,
    String customerName,
    String customerPhone,
    String serviceType,
    String description,
    String address,
    String status,
    String? conversationId,
    String? adminNotes,
    int? numberOfWorkers,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ServiceRequestCopyWithImpl<$Res, $Val extends ServiceRequest>
    implements $ServiceRequestCopyWith<$Res> {
  _$ServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? serviceType = null,
    Object? description = null,
    Object? address = null,
    Object? status = null,
    Object? conversationId = freezed,
    Object? adminNotes = freezed,
    Object? numberOfWorkers = freezed,
    Object? scheduledAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPhone: null == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceType: null == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: freezed == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            adminNotes: freezed == adminNotes
                ? _value.adminNotes
                : adminNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            numberOfWorkers: freezed == numberOfWorkers
                ? _value.numberOfWorkers
                : numberOfWorkers // ignore: cast_nullable_to_non_nullable
                      as int?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceRequestImplCopyWith<$Res>
    implements $ServiceRequestCopyWith<$Res> {
  factory _$$ServiceRequestImplCopyWith(
    _$ServiceRequestImpl value,
    $Res Function(_$ServiceRequestImpl) then,
  ) = __$$ServiceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String customerId,
    String customerName,
    String customerPhone,
    String serviceType,
    String description,
    String address,
    String status,
    String? conversationId,
    String? adminNotes,
    int? numberOfWorkers,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ServiceRequestImplCopyWithImpl<$Res>
    extends _$ServiceRequestCopyWithImpl<$Res, _$ServiceRequestImpl>
    implements _$$ServiceRequestImplCopyWith<$Res> {
  __$$ServiceRequestImplCopyWithImpl(
    _$ServiceRequestImpl _value,
    $Res Function(_$ServiceRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? serviceType = null,
    Object? description = null,
    Object? address = null,
    Object? status = null,
    Object? conversationId = freezed,
    Object? adminNotes = freezed,
    Object? numberOfWorkers = freezed,
    Object? scheduledAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ServiceRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPhone: null == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceType: null == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: freezed == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        adminNotes: freezed == adminNotes
            ? _value.adminNotes
            : adminNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        numberOfWorkers: freezed == numberOfWorkers
            ? _value.numberOfWorkers
            : numberOfWorkers // ignore: cast_nullable_to_non_nullable
                  as int?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceRequestImpl implements _ServiceRequest {
  const _$ServiceRequestImpl({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.description,
    required this.address,
    required this.status,
    this.conversationId,
    this.adminNotes,
    this.numberOfWorkers,
    this.scheduledAt,
    this.createdAt,
    this.updatedAt,
  });

  factory _$ServiceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String customerName;
  @override
  final String customerPhone;
  @override
  final String serviceType;
  @override
  final String description;
  @override
  final String address;
  @override
  final String status;
  @override
  final String? conversationId;
  // Admin fills these after speaking with customer
  @override
  final String? adminNotes;
  @override
  final int? numberOfWorkers;
  @override
  final DateTime? scheduledAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ServiceRequest(id: $id, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, serviceType: $serviceType, description: $description, address: $address, status: $status, conversationId: $conversationId, adminNotes: $adminNotes, numberOfWorkers: $numberOfWorkers, scheduledAt: $scheduledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.numberOfWorkers, numberOfWorkers) ||
                other.numberOfWorkers == numberOfWorkers) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    customerId,
    customerName,
    customerPhone,
    serviceType,
    description,
    address,
    status,
    conversationId,
    adminNotes,
    numberOfWorkers,
    scheduledAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceRequestImplCopyWith<_$ServiceRequestImpl> get copyWith =>
      __$$ServiceRequestImplCopyWithImpl<_$ServiceRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceRequestImplToJson(this);
  }
}

abstract class _ServiceRequest implements ServiceRequest {
  const factory _ServiceRequest({
    required final String id,
    required final String customerId,
    required final String customerName,
    required final String customerPhone,
    required final String serviceType,
    required final String description,
    required final String address,
    required final String status,
    final String? conversationId,
    final String? adminNotes,
    final int? numberOfWorkers,
    final DateTime? scheduledAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ServiceRequestImpl;

  factory _ServiceRequest.fromJson(Map<String, dynamic> json) =
      _$ServiceRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get serviceType;
  @override
  String get description;
  @override
  String get address;
  @override
  String get status;
  @override
  String? get conversationId; // Admin fills these after speaking with customer
  @override
  String? get adminNotes;
  @override
  int? get numberOfWorkers;
  @override
  DateTime? get scheduledAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceRequestImplCopyWith<_$ServiceRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
