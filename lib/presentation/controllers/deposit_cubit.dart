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
}
