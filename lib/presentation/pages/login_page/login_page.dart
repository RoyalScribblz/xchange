import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../controllers/accounts_cubit.dart";
import "../home_page/home_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(
      "dev-0zt0kwgn6ocwlua2.uk.auth0.com",
      "dgGpth3lChxHUBnfBIoivOtmm3k2MHJo",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_credentials == null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final credentials =
                      await auth0.webAuthentication(scheme: "xchange").login();

                  setState(() {
                    _credentials = credentials;
                  });
                },
                child: const Text("Login"),
              )
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => AccountsCubit(),
      child: const HomePage(),
    );
  }
}
