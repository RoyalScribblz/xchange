import "package:flutter/material.dart";

import "../../../fonts.dart";
import "../exchange_page/exchange_page.dart";
import "../home_page/home_page.dart";

class ExchangeSuccessPage extends StatelessWidget {
  const ExchangeSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            const Icon(Icons.check_circle, size: 150),
            Text(
              "Converted £75.00 GBP to",
              style: Fonts.neueMedium(20),
            ),
            Text(
              "\$95.28 USD",
              style: Fonts.neueBold(30),
            ),
            const Expanded(child: SizedBox()),
            const ContinueButton(
              label: "Return Home",
              destination: HomePage(),
            ),
          ],
        ),
      ),
    );
  }
}
