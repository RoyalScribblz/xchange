import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "../../../fonts.dart";

class ExchangePreviewPage extends StatelessWidget {
  const ExchangePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
              "USD 95.28",
              style: Fonts.neueMedium(30),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.2) ??
                    Colors.black,
                height: 1,
                thickness: 1,
              ),
            ),
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
                          "GBP",
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
                          "1 GBP = 1.27 USD",
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
                          "GBP (£) 75.00",
                          style: Fonts.neueLight(15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
