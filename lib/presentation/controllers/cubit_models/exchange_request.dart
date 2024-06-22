import "../../../data/dtos/currency.dart";

class ExchangeRequest {
  ExchangeRequest(
    this.amount,
    this.fromCurrency,
    this.toCurrency,
  );

  final String amount;
  final Currency fromCurrency;
  final Currency toCurrency;
}
