import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/withdraw_cubit.dart";
import "../common/square_image.dart";
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
                        child: SquareImage(
                          assetPath: account.currency.flagImageUrl,
                          size: 50,
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
                  Text("Payment Details:", style: Fonts.neueMedium(15)),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      label: Text("IBAN", style: Fonts.neueMedium(20)),
                    ),
                    style: Fonts.neueLight(20),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      label: Text("SWIFTBIC", style: Fonts.neueMedium(20)),
                    ),
                    style: Fonts.neueLight(20),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            ContinueButton(
              label: "Confirm Withdrawal",
              onPressed: () async {
                final validation = withdrawCubit.validate();

                if (validation.isNotEmpty) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Invalid Input", style: Fonts.neueMedium(15)),
                        content: Text(validation),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK", style: Fonts.neueMedium(15)),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

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
                        title: Text("ERROR", style: Fonts.neueMedium(15)),
                        actions: [
                          TextButton(
                            onPressed: () {},
                            child: Text("OK", style: Fonts.neueMedium(15)),
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
