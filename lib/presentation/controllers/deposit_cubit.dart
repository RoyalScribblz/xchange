import "package:flutter_bloc/flutter_bloc.dart";

import "cubit_models/deposit_request.dart";

class DepositCubit extends Cubit<DepositRequest> {
  DepositCubit() : super(DepositRequest(100, "", "", "", ""));

  void setAmount(double amount) {
    emit(
      DepositRequest(
        amount,
        state.cardholderName,
        state.cardNumber,
        state.expiryDate,
        state.cvvCvc,
      ),
    );
  }

  void setCardholderName(String cardholderName) {
    emit(
      DepositRequest(
        state.amount,
        cardholderName,
        state.cardNumber,
        state.expiryDate,
        state.cvvCvc,
      ),
    );
  }

  void setCardNumber(String cardNumber) {
    emit(
      DepositRequest(
        state.amount,
        state.cardholderName,
        cardNumber,
        state.expiryDate,
        state.cvvCvc,
      ),
    );
  }

  void setExpiryDate(String expiryDate) {
    emit(
      DepositRequest(
        state.amount,
        state.cardholderName,
        state.cardNumber,
        expiryDate,
        state.cvvCvc,
      ),
    );
  }

  void setCvvCvc(String cvvCvc) {
    emit(
      DepositRequest(
        state.amount,
        state.cardholderName,
        state.cardNumber,
        state.expiryDate,
        cvvCvc,
      ),
    );
  }

  String validate() {
    String response = "";
    if (state.cardholderName.isEmpty) {
      response += "Card Holder name is invalid. Cannot be empty.\n";
    }

    final int cardNumbers = state.cardNumber.replaceAll(" ", "").length;
    if (cardNumbers != 15 && cardNumbers != 16) {
      response += "Card Number is invalid. Should be 15 or 16 digits.\n";
    }

    final RegExp regExp = RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$");
    if (!regExp.hasMatch(state.expiryDate)) {
      response += "Expiry Date is invalid. Should be in MM/yy format.\n";
    }

    final cvv = int.tryParse(state.cvvCvc);
    final int cvvLength = cvv.toString().length;
    if (state.cvvCvc.isEmpty || cvv == null || (cvvLength != 3 && cvvLength != 4)) {
      response += "CVV/CVC is invalid. Should be 3 or 4 digits.\n";
    }

    return response;
  }
}
