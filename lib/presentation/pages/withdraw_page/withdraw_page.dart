import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/withdraw_cubit.dart";
import "../exchange_page/exchange_page.dart";
import "../exchange_success_page/exchange_success_page.dart";

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key, required this.account});

  final GetAccountsResponse account;

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    final WithdrawCubit withdrawCubit = context.watch<WithdrawCubit>();
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    "Withdraw Funds",
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
                          backgroundImage:
                              NetworkImage(account.currency.flagImageUrl),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "${account.currency.symbol}${withdrawCubit.state.amount.toStringAsFixed(2)}",
                              style: Fonts.neueMedium(30),
                            ),
                            Text(
                              "${account.currency.symbol}${account.balance.toStringAsFixed(2)}",
                              style: Fonts.neueLight(15),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon:
                              const Icon(Icons.keyboard_alt_outlined, size: 35),
                          onPressed: () => {},
                        ),
                      )
                    ],
                  ),
                  Slider(
                    value: withdrawCubit.state.amount,
                    max: account.balance,
                    onChanged: (double amount) =>
                        withdrawCubit.setAmount(amount),
                  ),
                  const SizedBox(height: 30),
                  const Text("Payment Details:"),
                  const SizedBox(height: 15),
                  const TextField(
                      decoration: InputDecoration(label: Text("IBAN"))),
                  const SizedBox(height: 15),
                  const TextField(
                      decoration: InputDecoration(label: Text("SWIFTBIC"))),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            ContinueButton(
              label: "Confirm Withdrawal",
              onPressed: () async {
                final bool success = await accountsCubit.withdraw(
                    account.accountId, withdrawCubit.state.amount);

                if (success) {
                  await nav.push(
                    MaterialPageRoute(
                      builder: (_) => SuccessPage(
                        mainText: "Withdraw Successful",
                        subText:
                            "${account.currency.symbol}${withdrawCubit.state.amount.toStringAsFixed(2)} ${account.currency.currencyCode}",
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
    );
  }
}
