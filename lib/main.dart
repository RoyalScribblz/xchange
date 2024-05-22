import "package:flutter/material.dart";
import "presentation/pages/currency_page/currency_page.dart";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const VotingApp());
}

class VotingApp extends StatelessWidget {
  const VotingApp({super.key});

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: "Xchange",
      theme: theme,
      home: const CurrencyPage(),
    );
  }
}
