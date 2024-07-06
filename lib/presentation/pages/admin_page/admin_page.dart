import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/dtos/currency.dart";
import "../../../fonts.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/limits_cubit.dart";
import "../common/spaced_column.dart";

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: () => {},
              child: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) =>
            setState(() => currentPageIndex = index),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.lock_outline),
            label: "Limits",
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            label: "Requests",
          ),
        ],
      ),
      body: SafeArea(
        child: [
          BlocProvider(
            create: (_) => LimitsCubit(),
            child: const LimitsPage(),
          ),
          const RequestsPage(),
        ][currentPageIndex],
      ),
    );
  }
}

class LimitsPage extends StatefulWidget {
  const LimitsPage({super.key});

  @override
  State<LimitsPage> createState() => _LimitsPageState();
}

class _LimitsPageState extends State<LimitsPage> {
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Future initStateAsync() async {
    final CurrenciesCubit currenciesCubit = context.read<CurrenciesCubit>();
    final LimitsCubit limitsCubit = context.read<LimitsCubit>();

    await currenciesCubit.update();
    limitsCubit.initialise(currenciesCubit.state);
  }

  @override
  Widget build(BuildContext context) {
    final LimitsCubit limitsCubit = context.watch<LimitsCubit>();
    final Map<Currency, TextEditingController> filtered =
        limitsCubit.getFilteredCurrencies();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: TextField(
            decoration: const InputDecoration(hintText: "Search"),
            onChanged: (value) => limitsCubit.setSearch(value),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SpacedColumn(
                spaceHeight: 7,
                children: [
                  for (Currency currency in filtered.keys)
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset(1, 2),
                            )
                          ]),
                          child: Image.asset(
                            currency.flagImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            "${currency.name} (${currency.symbol})",
                            style: Fonts.neueMedium(15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: filtered[currency],
                          ),
                        ),
                        IconButton(
                          onPressed: () => {},
                          icon: const Icon(Icons.check),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        //ContinueButton(label: "Save All", onPressed: () => {}),
      ],
    );
  }
}

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User ID: 7846578346543",
                          style: Fonts.neueMedium(15),
                        ),
                        Text(
                          "Amount: 23523526.23 £GBP",
                          style: Fonts.neueMedium(15),
                        ),
                        Text("Evidence:", style: Fonts.neueMedium(15)),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
