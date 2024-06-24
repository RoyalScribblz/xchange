import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/dtos/currency.dart";
import "../../../fonts.dart";
import "../../controllers/accounts_cubit.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/user_cubit.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    selectedCurrency =
        context.read<UserCubit>().state.user!.localCurrency.currencyId;
  }

  String selectedCurrency = "6c84631c-838b-403e-8e2b-38614d2e907d";

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    final CurrenciesCubit currenciesCubit = context.watch<CurrenciesCubit>();
    final UserCubit userCubit = context.watch<UserCubit>();
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
                    "Profile",
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
                  Text("Local Currency", style: Fonts.neueMedium(15)),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 60,
                    child: DropdownButton(
                      isExpanded: true,
                      value: selectedCurrency,
                      items: [
                        for (var currency in currenciesCubit.state)
                          DropdownMenuItem(
                            value: currency.currencyId,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage(currency.flagImageUrl),
                                ),
                                const SizedBox(width: 5),
                                Text("${currency.name} (${currency.symbol})"),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCurrency = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: FilledButton(
                      onPressed: () async {
                        await userCubit.updateLocalCurrency(selectedCurrency);
                        await accountsCubit.update(userCubit.state.user!.userId);

                        nav.pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Save",
                          style: Fonts.neueBold(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
