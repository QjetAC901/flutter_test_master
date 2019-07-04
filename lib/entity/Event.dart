import 'package:json_annotation/json_annotation.dart';

import 'EventPayload.dart';
import 'Repository.dart';
import 'User.dart';

/// Event
/// Created by Chen_Mr on 2019/7/2.


part 'Event.g.dart';

@JsonSerializable()
class Event {
  String id;
  String type;
  User actor;
  Repository repo;
  User org;
  EventPayload payload;
  @JsonKey(name: "public")
  bool isPublic;
  @JsonKey(name: "created_at")
  DateTime createdAt;

  Event(
      this.id,
      this.type,
      this.actor,
      this.repo,
      this.org,
      this.payload,
      this.isPublic,
      this.createdAt,
      );

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

}