import "package:flutter/material.dart";

import "../../../fonts.dart";
import "../exchange_page/exchange_page.dart";

class SuccessPage extends StatelessWidget {
  const SuccessPage({
    super.key,
    required this.mainText,
    required this.subText,
  });

  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            const Icon(Icons.check_circle, size: 150),
            Text(
              mainText,
              style: Fonts.neueMedium(20),
            ),
            Text(
              subText,
              style: Fonts.neueBold(30),
            ),
            const Expanded(child: SizedBox()),
            ContinueButton(
              label: "Return Home",
              onPressed: () => {
                Navigator.of(context).popUntil((route) => route.isFirst)
              },
            ),
          ],
        ),
      ),
    );
  }
}
