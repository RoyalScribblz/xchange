import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/deposit_cubit.dart";
import "../exchange_page/exchange_page.dart";
import "../exchange_success_page/exchange_success_page.dart";

class DepositPage extends StatelessWidget {
  const DepositPage({super.key, required this.account});

  final GetAccountsResponse account;

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    final DepositCubit depositCubit = context.watch<DepositCubit>();
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final minHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.keyboard_backspace),
                            onPressed: () => nav.pop(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Deposit Funds",
                            style: Fonts.neueBold(15),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      account.currency.flagImageUrl),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "${account.currency.symbol}${depositCubit.state.amount.toStringAsFixed(2)}",
                                    style: Fonts.neueMedium(30)),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.keyboard_alt_outlined,
                                      size: 35),
                                  onPressed: () => {},
                                ),
                              )
                            ],
                          ),
                          Slider(
                            value: depositCubit.state.amount,
                            max: 1000,
                            onChanged: (double amount) =>
                                depositCubit.setAmount(amount),
                          ),
                          const SizedBox(height: 30),
                          const Text("Payment Details:"),
                          const SizedBox(height: 15),
                          TextField(
                            onChanged: (String cardholderName) =>
                                depositCubit.setCardholderName(cardholderName),
                            decoration: const InputDecoration(
                              label: Text("Cardholder Name"),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            onChanged: (String cardNumber) =>
                                depositCubit.setCardNumber(cardNumber),
                            decoration: const InputDecoration(
                              label: Text("Card Number"),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            onChanged: (String expiryDate) =>
                                depositCubit.setExpiryDate(expiryDate),
                            decoration: const InputDecoration(
                              label: Text("Expiry Date"),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            onChanged: (String cvvCvc) =>
                                depositCubit.setCvvCvc(cvvCvc),
                            decoration: const InputDecoration(
                              label: Text("CVV/CVC"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Expanded(child: SizedBox()),
                    ContinueButton(
                      label: "Confirm Deposit",
                      onPressed: () async {
                        final bool success = await accountsCubit.deposit(
                            account.accountId, depositCubit.state.amount);

                        if (success) {
                          await nav.push(
                            MaterialPageRoute(
                              builder: (_) => SuccessPage(
                                mainText: "Deposit Successful",
                                subText: "${account.currency.symbol}${depositCubit.state.amount.toStringAsFixed(2)} ${account.currency.currencyCode}",
                              ),
                            ),
                          );
                          return;
                        }

                        if (context.mounted) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("ERROR"),
                                actions: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
