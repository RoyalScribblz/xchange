import "package:flutter/material.dart";

import "../../../fonts.dart";
import "../exchange_preview_page/exchange_preview_page.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text("Accounts", style: Fonts.neueBold(15)),
            ),
            const MyDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Text("Currency", style: Fonts.neueMedium(15)),
                        const Expanded(child: SizedBox()),
                        Text("Amount", style: Fonts.neueMedium(15)),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/383px-Flag_of_the_United_Kingdom_%281-2%29.svg.png"),
                      ),
                      const SizedBox(width: 15),
                      Text("GBP", style: Fonts.neueBold(20)),
                      const Expanded(child: SizedBox()),
                      Column(
                        children: [
                          Text("£257.28 GBP", style: Fonts.neueMedium(15)),
                          Text("£257.28 GBP", style: Fonts.neueLight(15)),
                        ],        
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.britannica.com/33/4833-004-828A9A84/Flag-United-States-of-America.jpg"),
                      ),
                      const SizedBox(width: 15),
                      Text("USD", style: Fonts.neueBold(20)),
                      const Expanded(child: SizedBox()),
                      Column(
                        children: [
                          Text("£95.28 USD", style: Fonts.neueMedium(15)),
                          Text("£74.17 GBP", style: Fonts.neueLight(15)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
