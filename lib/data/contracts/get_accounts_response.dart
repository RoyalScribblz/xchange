import "package:json_annotation/json_annotation.dart";

part "get_accounts_response.g.dart";

@JsonSerializable()
class GetAccountsResponse {

  GetAccountsResponse({
    required this.accountId,
    required this.userId,
    required this.currency,
    required this.balance,
  });

  factory GetAccountsResponse.fromJson(Map<String, dynamic> json) => _$GetAccountsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetAccountsResponseToJson(this);

  final String accountId;
  final String userId;
  final LocalCurrency currency;
  final double balance;
}

@JsonSerializable()
class LocalCurrency {

  LocalCurrency({
    required this.currencyId,
    required this.name,
    required this.currencyCode,
    required this.flagImageUrl,
    required this.symbol,
    required this.localValue,
    required this.transactionLimit,
  });

  factory LocalCurrency.fromJson(Map<String, dynamic> json) => _$LocalCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$LocalCurrencyToJson(this);

  final String currencyId;
  final String name;
  final String currencyCode;
  final String flagImageUrl;
  final String symbol;
  final double localValue;
  final double transactionLimit;
}
