import "package:flutter_bloc/flutter_bloc.dart";

import "cubit_models/withdraw_request.dart";

class WithdrawCubit extends Cubit<WithdrawRequest> {
  WithdrawCubit() : super(WithdrawRequest(100, "", ""));

  void setAmount(double amount) {
    emit(
      WithdrawRequest(amount, state.iban, state.swiftBic)
    );
  }

  void setIban(String iban) {
    emit(
        WithdrawRequest(state.amount, iban, state.swiftBic)
    );
  }

  void setSwiftBic(String swiftBic) {
    emit(
        WithdrawRequest(state.amount, state.iban, swiftBic)
    );
  }
}