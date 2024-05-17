import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

import "../../../fonts.dart";

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    const double keyboardFontSize = 30;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("X", style: Fonts.neueBold(30)),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Convert GBP", style: Fonts.neueBold(15)),
                      Text("£378.53 available (i)",
                          style: Fonts.neueMedium(15)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: Text("MAX", style: Fonts.neueBold(10)),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("USD 75.00", style: Fonts.neueMedium(50)),
                )
              ],
            ),
            const Expanded(child: SizedBox()),
            Container(
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
                    const Text("£"),
                    const SizedBox(width: 15),
                    const Column(
                      children: [
                        Text("From"),
                        Text("GBP"),
                      ],
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () => {},
                      child: const Icon(Icons.swap_horiz),
                    ),
                    const SizedBox(width: 30),
                    const Column(
                      children: [
                        Text("To"),
                        Text("USD"),
                      ],
                    ),
                    const SizedBox(width: 15),
                    const Text("\$"),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => {}, child: Text("1", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(onPressed: () => {}, child: Text("2", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(onPressed: () => {}, child: Text("3", style: Fonts.neueMedium(keyboardFontSize))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => {}, child: Text("4", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(onPressed: () => {}, child: Text("5", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(onPressed: () => {}, child: Text("6", style: Fonts.neueMedium(keyboardFontSize))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => {}, child: Text("7", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(onPressed: () => {}, child: Text("8", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(onPressed: () => {}, child: Text("9", style: Fonts.neueMedium(keyboardFontSize))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () => {}, child: Text(".", style: Fonts.neueMedium(keyboardFontSize))),
                TextButton(
                    onPressed: () => {}, child: Text("0", style: Fonts.neueMedium(keyboardFontSize))),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.keyboard_backspace),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FilledButton(
                      onPressed: () => {},
                      child: const Text("Preview Conversion"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
