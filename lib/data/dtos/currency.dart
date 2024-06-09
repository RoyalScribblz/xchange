import "package:json_annotation/json_annotation.dart";

part "currency.g.dart";

@JsonSerializable()
class Currency {

  Currency({
    required this.currencyId,
    required this.name,
    required this.currencyCode,
    required this.flagImageUrl,
    required this.symbol,
    required this.usdValue,
    required this.transactionLimit,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyToJson(this);

  final String currencyId;
  final String name;
  final String currencyCode;
  final String flagImageUrl;
  final String symbol;
  final double usdValue;
  final double transactionLimit;
}
