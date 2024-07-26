import "dart:core";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../data/contracts/get_user_response.dart";
import "../../../data/dtos/currency.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/deposit_cubit.dart";
import "../../controllers/exchange_cubit.dart";
import "../../controllers/home_page_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../../controllers/withdraw_cubit.dart";
import "../common/spaced_column.dart";
import "../common/square_image.dart";
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
    context.read<AccountsCubit>().update(userCubit.state.credentials);
    context.read<CurrenciesCubit>().update();
  }

  @override
  Widget build(BuildContext context) {
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();
    final UserCubit userCubit = context.watch<UserCubit>();
    final CurrenciesCubit currenciesCubit = context.watch<CurrenciesCubit>();

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
                  child: PopupMenuButton<Currency>(
                    icon: const Icon(Icons.add),
                    onSelected: (currency) => accountsCubit.createAccount(userCubit.state.credentials, currency.currencyId),
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
                                  Expanded(child: Text("${currency.name} (${currency.symbol})", style: Fonts.neueMedium(15),)),
                                ],
                              ),
                            ),
                          )
                          .toList();
                    },
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
                          account: account,
                          user: userCubit.state.user!,
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

class CurrencyTile extends StatelessWidget {
  const CurrencyTile({
    super.key,
    required this.account,
    required this.user,
  });

  final GetAccountsResponse account;
  final GetUserResponse user;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NavigatorState nav = Navigator.of(context);
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();
    final HomePageCubit homePageCubit = context.watch<HomePageCubit>();
    final UserCubit userCubit = context.watch<UserCubit>();

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => homePageCubit.setSelectedAccount(account),
          child: Row(
            children: [
              SquareImage(
                assetPath: account.currency.flagImageUrl,
                size: 50,
              ),
              const SizedBox(width: 15),
              Text(account.currency.currencyCode, style: Fonts.neueBold(20)),
              const Expanded(child: SizedBox()),
              Column(
                children: [
                  Text(
                      "${account.currency.symbol}${account.balance.toStringAsFixed(2)} ${account.currency.currencyCode}",
                      style: Fonts.neueMedium(15)),
                  Text(
                      "${user.localCurrency.symbol}${account.localValue.toStringAsFixed(2)} ${user.localCurrency.currencyCode}",
                      style: Fonts.neueLight(15)),
                ],
              ),
            ],
          ),
        ),
        if (homePageCubit.state.selectedAccount == account) ...[
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: theme.textTheme.bodyMedium?.color),
                    onPressed: () async => await nav.push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => ExchangeCubit(
                            account.currency,
                            accountsCubit.state
                                .singleWhereOrNull((a) =>
                                    a.currency.currencyId ==
                                    userCubit.state.user!.localCurrency.currencyId)
                                ?.currency ?? accountsCubit.state.first.currency,
                          ),
                          child: const ExchangePage(),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.swap_horiz),
                  ),
                  Text("Exchange", style: Fonts.neueMedium(12)),
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
                          child: DepositPage(account: account),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.download),
                  ),
                  Text("Deposit", style: Fonts.neueMedium(12)),
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
                          create: (_) => WithdrawCubit(account.balance),
                          child: WithdrawPage(account: account),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.upload),
                  ),
                  Text("Withdraw", style: Fonts.neueMedium(12)),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
