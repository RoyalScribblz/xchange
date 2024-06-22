import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/contracts/get_accounts_response.dart";
import "cubit_models/home_page_data.dart";

class HomePageCubit extends Cubit<HomePageData> {
  HomePageCubit() : super(HomePageData(null));

  void setSelectedAccount(GetAccountsResponse account) {
    emit(state.selectedAccount == account
        ? HomePageData(null)
        : HomePageData(account));
  }
}