class WithdrawRequest {
  WithdrawRequest(
    this.amount,
    this.iban,
    this.swiftBic,
  );

  final double amount;
  final String iban;
  final String swiftBic;
}
