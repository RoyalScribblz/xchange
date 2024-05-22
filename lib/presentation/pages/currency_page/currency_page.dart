import "package:flutter/material.dart";

class CurrencyPage extends StatelessWidget {
  const CurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_backspace),
                  onPressed: () {},
                ),
              ],
            ),
            const Text("Your balance"),
            const Row(
              children: [
                Text("GBP £1852.35"),
                Expanded(child: SizedBox()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: theme.textTheme.bodyMedium?.color),
                      onPressed: () => {},
                      icon: const Icon(Icons.swap_horiz),
                    ),
                    const Text("Exchange"),
                  ],
                ),
                Column(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: theme.textTheme.bodyMedium?.color),
                      onPressed: () => {},
                      icon: const Icon(Icons.download),
                    ),
                    const Text("Deposit"),
                  ],
                ),
                Column(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: theme.textTheme.bodyMedium?.color),
                      onPressed: () => {},
                      icon: const Icon(Icons.upload),
                    ),
                    const Text("Withdraw"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
