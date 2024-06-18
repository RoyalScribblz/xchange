import "package:flutter_bloc/flutter_bloc.dart";

import "cubit_models/withdraw_request.dart";

class WithdrawCubit extends Cubit<WithdrawRequest> {
  WithdrawCubit() : super(WithdrawRequest(100, "", ""));

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
}