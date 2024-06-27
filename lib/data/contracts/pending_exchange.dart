import "package:json_annotation/json_annotation.dart";

part "pending_exchange.g.dart";

@JsonSerializable()
class PendingExchange {

  PendingExchange({
    required this.pendingExchangeId,
    required this.fromCurrencyId,
    required this.fromAmount,
    required this.toCurrencyId,
    required this.toAmount
  });

  factory PendingExchange.fromJson(Map<String, dynamic> json) => _$PendingExchangeFromJson(json);
  Map<String, dynamic> toJson() => _$PendingExchangeToJson(this);

  final String pendingExchangeId;
  final String fromCurrencyId;
  final double fromAmount;
  final String toCurrencyId;
  final double toAmount;
}