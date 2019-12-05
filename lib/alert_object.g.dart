// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertObject _$AlertObjectFromJson(Map<String, dynamic> json) {
  return AlertObject(
    json['alert'] == null
        ? null
        : NotificationObject.fromJson(json['alert'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AlertObjectToJson(AlertObject instance) =>
    <String, dynamic>{
      'alert': instance.alert?.toJson(),
    };
