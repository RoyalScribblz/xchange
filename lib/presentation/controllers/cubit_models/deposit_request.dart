class DepositRequest {
  DepositRequest(
    this.amount,
    this.cardholderName,
    this.cardNumber,
    this.expiryDate,
    this.cvvCvc,
  );

  final double amount;
  final String cardholderName;
  final String cardNumber;
  final String expiryDate;
  final String cvvCvc;
}
