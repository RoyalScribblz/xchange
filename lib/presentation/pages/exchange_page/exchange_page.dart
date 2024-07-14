import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/dtos/currency.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/exchange_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../common/square_image.dart";
import "../exchange_preview_page/exchange_preview_page.dart";

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NavigatorState nav = Navigator.of(context);
    final ExchangeCubit exchangeCubit = context.watch<ExchangeCubit>();
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();
    final UserCubit userCubit = context.watch<UserCubit>();
    final CurrenciesCubit currenciesCubit = context.watch<CurrenciesCubit>();
    final double balance =
        accountsCubit.getBalance(exchangeCubit.state.fromCurrency.currencyId);

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
                    icon: const Icon(Icons.close),
                    onPressed: () => nav.pop(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                          "Convert ${exchangeCubit.state.fromCurrency.currencyCode}",
                          style: Fonts.neueBold(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${exchangeCubit.state.fromCurrency.symbol}${balance.toStringAsFixed(2)} available",
                            style: Fonts.neueMedium(15),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                              Icons.info_outline)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text(
                "${exchangeCubit.state.fromCurrency.currencyCode} ${exchangeCubit.state.amount}",
                style: Fonts.neueMedium(50)),
            ElevatedButton(
              onPressed: () =>
                  exchangeCubit.setAmount((balance * 100).round() / 100),
              child: Text("MAX", style: Fonts.neueBold(15)),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.2) ??
                              Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      PopupMenuButton<Currency>(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SquareImage(
                              assetPath:
                                  exchangeCubit.state.fromCurrency.flagImageUrl,
                              size: 50,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("From", style: Fonts.neueLight(15)),
                                Text(
                                  "${exchangeCubit.state.fromCurrency.currencyCode} (${exchangeCubit.state.fromCurrency.symbol})",
                                  style: Fonts.neueMedium(15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onSelected: (currency) =>
                            exchangeCubit.setFromCurrency(currency),
                        itemBuilder: (_) {
                          return currenciesCubit.state
                              .map(
                                (currency) => PopupMenuItem<Currency>(
                                  value: currency,
                                  child: Row(
                                    children: [
                                      SquareImage(
                                        assetPath: currency.flagImageUrl,
                                        size: 50,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Text(
                                              "${currency.name} (${currency.symbol})")),
                                    ],
                                  ),
                                ),
                              )
                              .toList();
                        },
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () => exchangeCubit.swapToAndFromCurrency(),
                        child: const Icon(Icons.swap_horiz),
                      ),
                      const SizedBox(width: 30),
                      PopupMenuButton<Currency>(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("To", style: Fonts.neueLight(15)),
                                Text(
                                  "${exchangeCubit.state.toCurrency.currencyCode} (${exchangeCubit.state.toCurrency.symbol})",
                                  style: Fonts.neueMedium(15),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            SquareImage(
                              assetPath:
                                  exchangeCubit.state.toCurrency.flagImageUrl,
                              size: 50,
                            ),
                          ],
                        ),
                        onSelected: (currency) =>
                            exchangeCubit.setToCurrency(currency),
                        itemBuilder: (_) {
                          return currenciesCubit.state
                              .map(
                                (currency) => PopupMenuItem<Currency>(
                                  value: currency,
                                  child: Row(
                                    children: [
                                      SquareImage(
                                        assetPath: currency.flagImageUrl,
                                        size: 50,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Text(
                                              "${currency.name} (${currency.symbol})")),
                                    ],
                                  ),
                                ),
                              )
                              .toList();
                        },
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1.6,
              crossAxisCount: 3,
              children: const [
                KeyboardButton("1"),
                KeyboardButton("2"),
                KeyboardButton("3"),
                KeyboardButton("4"),
                KeyboardButton("5"),
                KeyboardButton("6"),
                KeyboardButton("7"),
                KeyboardButton("8"),
                KeyboardButton("9"),
                KeyboardButton("."),
                KeyboardButton("0"),
                KeyboardButton(Icons.keyboard_backspace),
              ],
            ),
            ContinueButton(
              label: "Preview Exchange",
              onPressed: () async {
                final bool success = await exchangeCubit
                    .createExchange(userCubit.state.user!.userId);

                if (success == false) {
                  return;
                }

                await nav.push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                        create: (_) => exchangeCubit,
                        child: const ExchangePreviewPage()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: FilledButton(
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  label,
                  style: Fonts.neueBold(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton(this.widget, {super.key});

  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    final ExchangeCubit exchangeCubit = context.watch<ExchangeCubit>();

    final Widget button = widget is IconData
        ? IconButton(
            onPressed: () => exchangeCubit.amountBackspace(),
            icon: Icon(
              size: 30,
              widget as IconData,
              color: Theme.of(context).primaryColor,
            ),
          )
        : TextButton(
            onPressed: () {
              if (widget is String) {
                final String key = widget as String;
                exchangeCubit.amountKey(key);
              }
            },
            child: Text(
              widget is String ? widget as String : "",
              style: Fonts.neueMedium(30),
            ),
          );

    return Padding(
      padding: const EdgeInsets.all(15),
      child: button,
    );
  }
}
