import "dart:core";

import "package:flutter/material.dart";

import "../../../fonts.dart";
import "../deposit_page/deposit_page.dart";
import "../exchange_page/exchange_page.dart";
import "../exchange_preview_page/exchange_preview_page.dart";
import "../withdraw_page/withdraw_page.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => {},
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Accounts", style: Fonts.neueBold(15)),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
            const MyDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Text("Currency", style: Fonts.neueMedium(15)),
                        const Expanded(child: SizedBox()),
                        Text("Amount", style: Fonts.neueMedium(15)),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  const CurrencyTile(
                    countryFlagImagePath:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/383px-Flag_of_the_United_Kingdom_%281-2%29.svg.png",
                    currencyCode: "GBP",
                    currencyAmount: "£257.28 GBP",
                    localCurrencyAmount: "£257.28 GBP",
                  ),
                  const SizedBox(height: 15),
                  const CurrencyTile(
                    countryFlagImagePath:
                        "https://cdn.britannica.com/33/4833-004-828A9A84/Flag-United-States-of-America.jpg",
                    currencyCode: "USD",
                    currencyAmount: "£95.28 USD",
                    localCurrencyAmount: "£74.17 GBP",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyTile extends StatefulWidget {
  const CurrencyTile({
    super.key,
    required this.countryFlagImagePath,
    required this.currencyCode,
    required this.currencyAmount,
    required this.localCurrencyAmount,
  });

  final String countryFlagImagePath;
  final String currencyCode;
  final String currencyAmount;
  final String localCurrencyAmount;

  @override
  State<CurrencyTile> createState() => _CurrencyTileState();
}

class _CurrencyTileState extends State<CurrencyTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NavigatorState nav = Navigator.of(context);

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => selected = !selected),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.countryFlagImagePath),
              ),
              const SizedBox(width: 15),
              Text(widget.currencyCode, style: Fonts.neueBold(20)),
              const Expanded(child: SizedBox()),
              Column(
                children: [
                  Text(widget.currencyAmount, style: Fonts.neueMedium(15)),
                  Text(widget.localCurrencyAmount, style: Fonts.neueLight(15)),
                ],
              ),
            ],
          ),
        ),
        if (selected) ...[
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: theme.textTheme.bodyMedium?.color),
                    onPressed: () async => await nav.push(MaterialPageRoute(
                        builder: (_) => const ExchangePage())),
                    icon: const Icon(Icons.swap_horiz),
                  ),
                  const Text("Exchange"),
                ],
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: theme.textTheme.bodyMedium?.color),
                    onPressed: () async => await nav.push(
                        MaterialPageRoute(builder: (_) => const DepositPage())),
                    icon: const Icon(Icons.download),
                  ),
                  const Text("Deposit"),
                ],
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: theme.textTheme.bodyMedium?.color),
                    onPressed: () async => await nav.push(MaterialPageRoute(
                        builder: (_) => const WithdrawPage())),
                    icon: const Icon(Icons.upload),
                  ),
                  const Text("Withdraw"),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
