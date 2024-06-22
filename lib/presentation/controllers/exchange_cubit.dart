import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/dtos/currency.dart";
import "cubit_models/exchange_request.dart";

class ExchangeCubit extends Cubit<ExchangeRequest> {
  ExchangeCubit(Currency fromCurrency, Currency toCurrency)
      : super(ExchangeRequest("10.00", fromCurrency, toCurrency));

  void setAmount(double amount) {
    emit(
      ExchangeRequest(
          amount.toStringAsFixed(2), state.fromCurrency, state.toCurrency),
    );
  }

  void setFromCurrency(Currency fromCurrency) {
    emit(
      ExchangeRequest(state.amount, fromCurrency, state.toCurrency),
    );
  }

  void setToCurrency(Currency toCurrency) {
    emit(
      ExchangeRequest(state.amount, state.fromCurrency, toCurrency),
    );
  }

  void swapToAndFromCurrency() {
    emit(
      ExchangeRequest(state.amount, state.toCurrency, state.fromCurrency),
    );
  }

  void amountBackspace() {
    if (state.amount.isEmpty) {
      return;
    }

    emit(
      ExchangeRequest(
        state.amount.substring(0, state.amount.length - 1),
        state.fromCurrency,
        state.toCurrency,
      ),
    );
  }

  void amountKey(String key) {
    if (key == "." && state.amount.contains(key)) {
      return;
    }

    if (RegExp(r"\.[a-zA-Z0-9]{2}").hasMatch(state.amount)) {
      return;
    }

    emit(
      ExchangeRequest(
        "${state.amount}$key",
        state.fromCurrency,
        state.toCurrency,
      ),
    );
  }
}
