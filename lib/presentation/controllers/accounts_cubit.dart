import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/contracts/get_accounts_response.dart";
import "../../data/repositories/account_repository.dart";

class AccountsCubit extends Cubit<List<GetAccountsResponse>> {
  AccountsCubit() : super([]);

  Future update(String userId) async {
    emit(await AccountRepository.getAccounts(userId));
  }
}