import 'package:json_annotation/json_annotation.dart';

part 'notification_object.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class NotificationObject {
  // fields go here
  String body;
  String title;
  // Add your fields to the constructor
  NotificationObject(this.body, this.title);

  factory NotificationObject.fromJson(Map<String, dynamic> json) =>
      _$NotificationObjectFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationObjectToJson(this);
}
