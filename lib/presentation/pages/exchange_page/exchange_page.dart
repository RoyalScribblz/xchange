import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

import "../../../fonts.dart";
import "../exchange_preview_page/exchange_preview_page.dart";

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

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
                    icon: const Icon(Icons.close),
                    onPressed: () => nav.pop(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Convert GBP", style: Fonts.neueBold(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "£378.53 available",
                            style: Fonts.neueMedium(15),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                              Icons.info_outline) // TODO make this do something
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text("GBP 75.00", style: Fonts.neueMedium(50)),
            ElevatedButton(
              onPressed: () => {},
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
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/383px-Flag_of_the_United_Kingdom_%281-2%29.svg.png"),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("From", style: Fonts.neueLight(15)),
                          Text("GBP (£)", style: Fonts.neueMedium(15)),
                        ],
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () => {},
                        child: const Icon(Icons.swap_horiz),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("To", style: Fonts.neueLight(15)),
                          Text(r"USD ($)", style: Fonts.neueMedium(15)),
                        ],
                      ),
                      const SizedBox(width: 15),
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.britannica.com/33/4833-004-828A9A84/Flag-United-States-of-America.jpg"),
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
            const ContinueButton(
              label: "Preview Exchange",
              destination: ExchangePreviewPage(),
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
    required this.destination,
  });

  final String label;
  final Widget? destination;

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: FilledButton(
              onPressed: () async {
                if (destination != null) {
                  await nav.push(MaterialPageRoute(builder: (_) => destination!));
                }

                nav.popUntil((route) => route.isFirst);
              },
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
    final Widget button = widget is IconData
        ? IconButton(
            onPressed: () => {},
            icon: Icon(widget as IconData),
          )
        : TextButton(
            onPressed: () => {},
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
