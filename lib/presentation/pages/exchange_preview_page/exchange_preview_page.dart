import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/contracts/get_accounts_response.dart";
import "../../../data/contracts/pending_exchange.dart";
import "../../../data/dtos/currency.dart";
import "../../../data/dtos/evidence_request.dart";
import "../../../data/repositories/evidence_request_repository.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/exchange_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../exchange_page/exchange_page.dart";
import "../exchange_success_page/exchange_success_page.dart";

class ExchangePreviewPage extends StatelessWidget {
  const ExchangePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    final UserCubit userCubit = context.watch<UserCubit>();
    final ExchangeCubit exchangeCubit = context.watch<ExchangeCubit>();
    final CurrenciesCubit currenciesCubit = context.watch<CurrenciesCubit>();
    final AccountsCubit accountsCubit = context.watch<AccountsCubit>();
    final Currency toCurrency = currenciesCubit.state.singleWhere((c) =>
        c.currencyId == exchangeCubit.state.pendingExchange!.toCurrencyId);
    final Currency fromCurrency = currenciesCubit.state.singleWhere((c) =>
        c.currencyId == exchangeCubit.state.pendingExchange!.fromCurrencyId);
    final PendingExchange pendingExchange =
        exchangeCubit.state.pendingExchange!;

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
                  child: Text("Exchange Preview", style: Fonts.neueBold(15)),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Text(
              "${toCurrency.currencyCode} ${pendingExchange.toAmount}",
              style: Fonts.neueMedium(30),
            ),
            const SizedBox(height: 50),
            const MyDivider(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pay with",
                          style: Fonts.neueMedium(15),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          fromCurrency.currencyCode,
                          style: Fonts.neueLight(15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Exchange rate",
                          style: Fonts.neueMedium(15),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "1 ${fromCurrency.currencyCode} = ${(pendingExchange.toAmount / pendingExchange.fromAmount).toStringAsFixed(2)} ${toCurrency.currencyCode}",
                          style: Fonts.neueLight(15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Total",
                          style: Fonts.neueMedium(15),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${fromCurrency.currencyCode} (${fromCurrency.symbol}) ${pendingExchange.fromAmount.toStringAsFixed(2)}",
                          style: Fonts.neueLight(15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            ContinueButton(
              label: "Exchange Now",
              onPressed: () async {
                final List<GetAccountsResponse> accounts = await exchangeCubit.completeExchange(userCubit.state.user!.userId);

                if (accounts.isEmpty) {
                  return;
                }

                accountsCubit.set(accounts);

                final EvidenceRequest? evidenceRequest = await EvidenceRequestRepository.getEvidenceRequest(userCubit.state.user!.userId, EvidenceRequestStatus.waiting);

                await nav.push(
                  MaterialPageRoute(
                    builder: (_) => SuccessPage(
                      mainText: "Converted ${fromCurrency.symbol}${pendingExchange.fromAmount.toStringAsFixed(2)} ${fromCurrency.currencyCode} to",
                      subText: "${toCurrency.symbol}${pendingExchange.toAmount.toStringAsFixed(2)} ${toCurrency.currencyCode}",
                      frozen: evidenceRequest != null,
                    ),
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

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color:
            theme.textTheme.bodyMedium?.color?.withOpacity(0.2) ?? Colors.black,
        height: 1,
        thickness: 1,
      ),
    );
  }
}
