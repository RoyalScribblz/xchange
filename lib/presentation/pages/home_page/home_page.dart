import "dart:core";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/deposit_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../common/spaced_column.dart";
import "../deposit_page/deposit_page.dart";
import "../exchange_page/exchange_page.dart";
import "../exchange_preview_page/exchange_preview_page.dart";
import "../profile_page/profile_page.dart";
import "../withdraw_page/withdraw_page.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final UserCubit userCubit = context.read<UserCubit>();
    context.read<AccountsCubit>().update(userCubit.state.user!.userId);
  }

  @override
  Widget build(BuildContext context) {
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();
    final UserCubit userCubit = context.watch<UserCubit>();

    final NavigatorState nav = Navigator.of(context);

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
                    onPressed: () => nav.push(
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    ),
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
                  SpacedColumn(
                    spaceHeight: 15,
                    children: [
                      for (var account in accountsCubit.state)
                        CurrencyTile(
                          countryFlagImagePath: account.currency.flagImageUrl,
                          currencyCode: account.currency.currencyCode,
                          currencyAmount: account.balance,
                          currencySymbol: account.currency.symbol,
                          localCurrencyCode:
                              userCubit.state.user!.localCurrency.currencyCode,
                          localCurrencyAmount: account.localValue,
                          localCurrencySymbol:
                              userCubit.state.user!.localCurrency.symbol,
                        ),
                    ],
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
    required this.currencySymbol,
    required this.localCurrencyCode,
    required this.localCurrencyAmount,
    required this.localCurrencySymbol,
  });

  final String countryFlagImagePath;
  final String currencyCode;
  final double currencyAmount;
  final String currencySymbol;
  final String localCurrencyCode;
  final double localCurrencyAmount;
  final String localCurrencySymbol;

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
                  Text(
                      "${widget.currencySymbol}${widget.currencyAmount.toStringAsFixed(2)} ${widget.currencyCode}",
                      style: Fonts.neueMedium(15)),
                  Text(
                      "${widget.localCurrencySymbol}${widget.localCurrencyAmount.toStringAsFixed(2)} ${widget.localCurrencyCode}",
                      style: Fonts.neueLight(15)),
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
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => DepositCubit(),
                          child: const DepositPage(),
                        ),
                      ),
                    ),
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
