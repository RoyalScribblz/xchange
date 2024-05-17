import "package:flutter/material.dart";
import "presentation/pages/exchange_page/exchange_page.dart";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const VotingApp());
}

class VotingApp extends StatelessWidget {
  const VotingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Xchange",
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const ExchangePage(),
    );
  }
}
