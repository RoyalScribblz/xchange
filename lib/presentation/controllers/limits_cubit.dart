import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/dtos/currency.dart";
import "../../data/repositories/currency_repository.dart";
import "cubit_models/limits_data.dart";

class LimitsCubit extends Cubit<LimitsData> {
  LimitsCubit() : super(LimitsData("", [], []));

  void initialise(List<Currency> currencies) {
    final List<TextEditingController> controllers = [];

    for (Currency currency in currencies) {
      controllers.add(
        TextEditingController(
          text: currency.transactionLimit.toStringAsFixed(2),
        ),
      );
    }

    emit(LimitsData(state.search, currencies, controllers));
  }

  void setSearch(String search) {
    emit(LimitsData(search, state.currencies, state.controllers));
  }

  Map<Currency, TextEditingController> getFilteredCurrencies() {
    if (state.controllers.isEmpty || state.currencies.isEmpty) {
      return {};
    }

    final Map<Currency, TextEditingController> filtered = {};

    for (int i = 0; i < state.currencies.length; i++) {
      final Currency currency = state.currencies[i];
      if (currency.name.containsIgnoreCase(state.search) ||
          currency.currencyCode.containsIgnoreCase(state.search) ||
          currency.symbol.containsIgnoreCase(state.search)) {
        filtered[currency] = state.controllers[i];
      }
    }

    return filtered;
  }

  Future<double?> setCurrencyLimit(Currency currency) async {
    final int index = state.currencies.indexOf(currency);
    final double? amount = double.tryParse(state.controllers[index].text);

    if (amount == null) {
      return null;
    }

    final bool success = await CurrencyRepository.setCurrencyLimit(currency.currencyId, amount);

    if (success) {
      state.currencies[index] = Currency(
        currencyId: currency.currencyId,
        name: currency.name,
        currencyCode: currency.currencyCode,
        flagImageUrl: currency.flagImageUrl,
        symbol: currency.symbol,
        usdValue: currency.usdValue,
        transactionLimit: currency.transactionLimit,
      );

      emit(LimitsData(state.search, state.currencies, state.controllers));
      return amount;
    }

    return null;
  }

  Future<Map<String, String>> setCurrencyLimits() async {
    final Map<String, String> changedValues = {};

    for (int i = 0; i < state.currencies.length; i++) {
      final Currency currency = state.currencies[i];
      final TextEditingController controller = state.controllers[i];

      final double? amount = double.tryParse(controller.text);
      if (currency.transactionLimit == amount) {
        continue;
      }

      if (amount == null) {
        continue;
      }

      final bool success = await CurrencyRepository.setCurrencyLimit(currency.currencyId, amount);

      if (success) {
        state.currencies[i] = Currency(
          currencyId: currency.currencyId,
          name: currency.name,
          currencyCode: currency.currencyCode,
          flagImageUrl: currency.flagImageUrl,
          symbol: currency.symbol,
          usdValue: currency.usdValue,
          transactionLimit: currency.transactionLimit,
        );

        changedValues[currency.currencyCode] = amount.toStringAsFixed(2);
      }
    }

    if (changedValues.isNotEmpty) {
      emit(LimitsData(state.search, state.currencies, state.controllers));
    }

    return changedValues;
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String string) =>
      toLowerCase().contains(string.toLowerCase());
}
