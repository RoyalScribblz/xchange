import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:collection/collection.dart";

import "../../data/contracts/get_accounts_response.dart";
import "../../data/repositories/account_repository.dart";

class AccountsCubit extends Cubit<List<GetAccountsResponse>> {
  AccountsCubit() : super([]);

  Future update(Credentials? credentials) async {
    emit(await AccountRepository.getAccounts(credentials));
  }

  void set(List<GetAccountsResponse> accounts) {
    emit([...accounts]);
  }

  Future<bool> deposit(String accountId, double amount, Credentials? credentials) async {
    final GetAccountsResponse? response =
        await AccountRepository.deposit(accountId, amount, credentials);

    if (response == null) {
      return false;
    }

    final updatedAccounts = state.map((account) {
      return account.accountId == accountId ? response : account;
    }).toList();

    emit(updatedAccounts);
    return true;
  }

  Future<bool> withdraw(String accountId, double amount, Credentials? credentials) async {
    final GetAccountsResponse? response =
        await AccountRepository.withdraw(accountId, amount, credentials);

    if (response == null) {
      return false;
    }

    final updatedAccounts = state.map((account) {
      return account.accountId == accountId ? response : account;
    }).toList();

    emit(updatedAccounts);
    return true;
  }

  double getBalance(String currencyId) {
    final GetAccountsResponse? account =
        state.singleWhereOrNull((a) => a.currency.currencyId == currencyId);

    if (account == null) {
      return 0;
    }

    return account.balance;
  }

  Future createAccount(Credentials? credentials, String currencyId) async {
    final GetAccountsResponse? account =
        await AccountRepository.create(credentials, currencyId);

    if (account == null) {
      return;
    }
    emit([...state, account]);
  }
}
