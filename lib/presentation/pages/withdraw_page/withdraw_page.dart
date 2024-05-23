import "package:flutter/material.dart";

import "../../../fonts.dart";
import "../exchange_page/exchange_page.dart";
import "../exchange_success_page/exchange_success_page.dart";

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    "Withdraw Funds",
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/383px-Flag_of_the_United_Kingdom_%281-2%29.svg.png"),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text("£100.00", style: Fonts.neueMedium(30)),
                            Text("£398.73", style: Fonts.neueLight(15)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon:
                              const Icon(Icons.keyboard_alt_outlined, size: 35),
                          onPressed: () => {},
                        ),
                      )
                    ],
                  ),
                  Slider(value: 30, max: 100, onChanged: (_) => {}),
                  const SizedBox(height: 30),
                  const Text("Payment Details:"),
                  const SizedBox(height: 15),
                  const TextField(
                      decoration: InputDecoration(label: Text("IBAN"))),
                  const SizedBox(height: 15),
                  const TextField(
                      decoration: InputDecoration(label: Text("SWIFTBIC"))),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            const ContinueButton(
              label: "Confirm Withdrawal",
              destination: SuccessPage(
                mainText: "Withdraw Successful",
                subText: r"£100.00 GBP",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
