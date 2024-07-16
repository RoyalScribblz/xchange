import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../fonts.dart";
import "../../controllers/evidence_cubit.dart";
import "../exchange_page/exchange_page.dart";
import "../frozen_page/frozen_page.dart";

class SuccessPage extends StatelessWidget {
  const SuccessPage({
    super.key,
    required this.mainText,
    required this.subText,
    this.frozen = false,
  });

  final String mainText;
  final String subText;
  final bool frozen;

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
              onPressed: () {
                final NavigatorState nav = Navigator.of(context);

                if (frozen) {
                  nav.push(MaterialPageRoute(builder: (_) => const FrozenPage()));

                  return;
                }

                nav.popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
