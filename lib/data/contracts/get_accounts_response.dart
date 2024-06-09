import "package:json_annotation/json_annotation.dart";

import "../dtos/currency.dart";

part "get_accounts_response.g.dart";

@JsonSerializable()
class GetAccountsResponse {

  GetAccountsResponse({
    required this.accountId,
    required this.userId,
    required this.currency,
    required this.balance,
    required this.localValue
  });

  factory GetAccountsResponse.fromJson(Map<String, dynamic> json) => _$GetAccountsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetAccountsResponseToJson(this);

  final String accountId;
  final String userId;
  final Currency currency;
  final double balance;
  final double localValue;
}