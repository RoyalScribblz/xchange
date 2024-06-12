import "package:json_annotation/json_annotation.dart";

import "../dtos/currency.dart";

part "get_user_response.g.dart";

@JsonSerializable()
class GetUserResponse {

  GetUserResponse({
    required this.userId,
    required this.localCurrency,
    required this.isFrozen,
    required this.isBanned,
  });

  factory GetUserResponse.fromJson(Map<String, dynamic> json) => _$GetUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetUserResponseToJson(this);

  final String userId;
  final Currency localCurrency;
  final bool isFrozen;
  final bool isBanned;
}