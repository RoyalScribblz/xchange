import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/dtos/currency.dart";
import "../../data/repositories/currency_repository.dart";

class CurrenciesCubit extends Cubit<List<Currency>> {
  CurrenciesCubit() : super([]);

  Future update() async {
    final List<Currency> currencies = await CurrencyRepository.getCurrencies();
    currencies.sort((a, b) => a.name.compareTo(b.name));

    emit(currencies);
  }
}