import "../../../data/contracts/pending_exchange.dart";
import "../../../data/dtos/currency.dart";

class ExchangeRequest {
  ExchangeRequest(
    this.amount,
    this.fromCurrency,
    this.toCurrency,
    this.pendingExchange,
  );

  final String amount;
  final Currency fromCurrency;
  final Currency toCurrency;
  final PendingExchange? pendingExchange;
}
