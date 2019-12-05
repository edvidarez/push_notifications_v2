// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationObject _$NotificationObjectFromJson(Map<String, dynamic> json) {
  return NotificationObject(
    json['body'] as String,
    json['title'] as String,
  );
}

Map<String, dynamic> _$NotificationObjectToJson(NotificationObject instance) =>
    <String, dynamic>{
      'body': instance.body,
      'title': instance.title,
    };
