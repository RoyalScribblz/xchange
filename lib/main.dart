import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "presentation/controllers/user_cubit.dart";
import "presentation/pages/login_page/login_page.dart";

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
      home: BlocProvider(
        create: (_) => UserCubit(),
        child: const LoginPage(),
      ),
    );
  }
}
