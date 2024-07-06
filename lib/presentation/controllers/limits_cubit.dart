import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/dtos/currency.dart";
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
}

extension StringExtensions on String {
  bool containsIgnoreCase(String string) =>
      toLowerCase().contains(string.toLowerCase());
}
