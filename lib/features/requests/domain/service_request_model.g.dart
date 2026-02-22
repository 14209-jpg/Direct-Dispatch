// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceRequestImpl _$$ServiceRequestImplFromJson(Map<String, dynamic> json) =>
    _$ServiceRequestImpl(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      serviceType: json['serviceType'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
      conversationId: json['conversationId'] as String?,
      adminNotes: json['adminNotes'] as String?,
      numberOfWorkers: (json['numberOfWorkers'] as num?)?.toInt(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ServiceRequestImplToJson(
  _$ServiceRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerPhone': instance.customerPhone,
  'serviceType': instance.serviceType,
  'description': instance.description,
  'address': instance.address,
  'status': instance.status,
  'conversationId': instance.conversationId,
  'adminNotes': instance.adminNotes,
  'numberOfWorkers': instance.numberOfWorkers,
  'scheduledAt': instance.scheduledAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
