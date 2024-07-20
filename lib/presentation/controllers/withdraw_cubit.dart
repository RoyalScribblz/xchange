import "package:flutter_bloc/flutter_bloc.dart";

import "cubit_models/withdraw_request.dart";

class WithdrawCubit extends Cubit<WithdrawRequest> {
  WithdrawCubit(double balance) : super(WithdrawRequest(balance, "", ""));

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

  String validate() {
    String response = "";
    final ibanRegex = RegExp(r"^([A-Z]{2}[ \-]?[0-9]{2})(?=(?:[ \-]?[A-Z0-9]){9,30}$)((?:[ \-]?[A-Z0-9]{3,5}){2,7})([ \-]?[A-Z0-9]{1,3})?$");
    if (!ibanRegex.hasMatch(state.iban)) {
      response += "IBAN is invalid. Check IBAN formatting.\n";
    }

    final swiftBicRegex = RegExp(r"^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$");
    if (!swiftBicRegex.hasMatch(state.swiftBic)) {
      response += "SWIFTBIC is invalid. Check SWIFTBIC formatting.\n";
    }
    return response;
  }
}