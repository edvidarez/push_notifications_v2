import 'package:json_annotation/json_annotation.dart';
import 'package:push_notifications_v2/notification_object.dart';

part 'alert_object.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated and having nested objects.
@JsonSerializable(explicitToJson: true)
class AlertObject {
  // fields go here
  NotificationObject alert;
  // Add your fields to the constructor
  AlertObject(this.alert);

  factory AlertObject.fromJson(Map<String, dynamic> json) =>
      _$AlertObjectFromJson(json);

  Map<String, dynamic> toJson() => _$AlertObjectToJson(this);
}
