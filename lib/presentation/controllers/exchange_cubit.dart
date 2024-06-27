import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/contracts/get_accounts_response.dart";
import "../../data/contracts/pending_exchange.dart";
import "../../data/dtos/currency.dart";
import "../../data/repositories/account_repository.dart";
import "cubit_models/exchange_request.dart";

class ExchangeCubit extends Cubit<ExchangeRequest> {
  ExchangeCubit(Currency fromCurrency, Currency toCurrency)
      : super(ExchangeRequest("10.00", fromCurrency, toCurrency, null));

  void setAmount(double amount) {
    emit(
      ExchangeRequest(
        amount.toStringAsFixed(2),
        state.fromCurrency,
        state.toCurrency,
        state.pendingExchange,
      ),
    );
  }

  void setFromCurrency(Currency fromCurrency) {
    emit(
      ExchangeRequest(
        state.amount,
        fromCurrency,
        state.toCurrency,
        state.pendingExchange,
      ),
    );
  }

  void setToCurrency(Currency toCurrency) {
    emit(
      ExchangeRequest(
        state.amount,
        state.fromCurrency,
        toCurrency,
        state.pendingExchange,
      ),
    );
  }

  void swapToAndFromCurrency() {
    emit(
      ExchangeRequest(
        state.amount,
        state.toCurrency,
        state.fromCurrency,
        state.pendingExchange,
      ),
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
        state.pendingExchange,
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
        state.pendingExchange,
      ),
    );
  }

  Future<bool> createExchange(String userId) async {
    final double? amountDouble = double.tryParse(state.amount);

    if (amountDouble == null) {
      return false;
    }

    final PendingExchange? pendingExchange =
        await AccountRepository.createExchange(userId, amountDouble,
            state.fromCurrency.currencyId, state.toCurrency.currencyId);

    if (pendingExchange == null) {
      return false;
    }

    emit(
      ExchangeRequest(
        state.amount,
        state.fromCurrency,
        state.toCurrency,
        pendingExchange,
      ),
    );

    return true;
  }

  Future<List<GetAccountsResponse>> completeExchange(String userId) async {
    if (state.pendingExchange == null) {
      return [];
    }

    return await AccountRepository.completeExchange(
        userId, state.pendingExchange!.pendingExchangeId);
  }
}
