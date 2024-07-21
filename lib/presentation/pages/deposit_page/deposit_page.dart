import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/deposit_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../common/square_image.dart";
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
    final UserCubit userCubit = context.watch<UserCubit>();

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
                                child: SquareImage(
                                  assetPath: account.currency.flagImageUrl,
                                  size: 50,
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
                          Text("Payment Details:", style: Fonts.neueMedium(15)),
                          const SizedBox(height: 15),
                          TextField(
                            onChanged: (String cardholderName) =>
                                depositCubit.setCardholderName(cardholderName),
                            decoration: InputDecoration(
                              label: Text("Cardholder Name",
                                  style: Fonts.neueMedium(20)),
                            ),
                            style: Fonts.neueLight(20),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String cardNumber) =>
                                depositCubit.setCardNumber(cardNumber),
                            decoration: InputDecoration(
                              label: Text("Card Number",
                                  style: Fonts.neueMedium(20)),
                            ),
                            style: Fonts.neueLight(20),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (String expiryDate) =>
                                depositCubit.setExpiryDate(expiryDate),
                            decoration: InputDecoration(
                              label: Text("Expiry Date",
                                  style: Fonts.neueMedium(20)),
                            ),
                            style: Fonts.neueLight(20),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String cvvCvc) =>
                                depositCubit.setCvvCvc(cvvCvc),
                            decoration: InputDecoration(
                              label:
                                  Text("CVV/CVC", style: Fonts.neueMedium(20)),
                            ),
                            style: Fonts.neueLight(20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Expanded(child: SizedBox()),
                    ContinueButton(
                      label: "Confirm Deposit",
                      onPressed: () async {
                        if (depositCubit.state.amount <= 0) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Invalid Deposit",
                                    style: Fonts.neueMedium(15)),
                                content: const Text(
                                    "Amount to deposit must be more than 0."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child:
                                        Text("OK", style: Fonts.neueMedium(15)),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        final validation = depositCubit.validate();

                        if (validation.isNotEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Invalid Input",
                                    style: Fonts.neueMedium(15)),
                                content: Text(validation),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child:
                                        Text("OK", style: Fonts.neueMedium(15)),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        final bool success = await accountsCubit.deposit(
                            account.accountId,
                            depositCubit.state.amount,
                            userCubit.state.credentials);

                        if (success) {
                          await nav.push(
                            MaterialPageRoute(
                              builder: (_) => SuccessPage(
                                mainText: "Deposit Successful",
                                subText:
                                    "${account.currency.symbol}${depositCubit.state.amount.toStringAsFixed(2)} ${account.currency.currencyCode}",
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
                                title:
                                    Text("ERROR", style: Fonts.neueMedium(15)),
                                actions: [
                                  TextButton(
                                    onPressed: () {},
                                    child:
                                        Text("OK", style: Fonts.neueMedium(15)),
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
