import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:local_auth/local_auth.dart" as local_auth;

import "../../../data/dtos/evidence_request.dart";
import "../../../extensions/credentials_extensions.dart";
import "../../../fonts.dart";
import "../../controllers/evidence_cubit.dart";
import "../../controllers/home_page_cubit.dart";
import "../../controllers/limits_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../admin_page/admin_page.dart";
import "../frozen_page/frozen_page.dart";
import "../home_page/home_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Auth0 auth0;
  final local_auth.LocalAuthentication localAuth =
      local_auth.LocalAuthentication();

  bool locallyAuthenticated = false;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(
      "dev-0zt0kwgn6ocwlua2.uk.auth0.com",
      "dgGpth3lChxHUBnfBIoivOtmm3k2MHJo",
    );

    biometricAuthenticate();
  }

  Future biometricAuthenticate() async {
    final List<local_auth.BiometricType> biometrics =
        await localAuth.getAvailableBiometrics();

    if (biometrics.isEmpty) {
      return;
    }

    try {
      final bool success = await localAuth.authenticate(
          localizedReason: "Please authenticate to access the application");
      setState(() => locallyAuthenticated = success);
    } on Exception {
      setState(() => locallyAuthenticated = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserCubit userCubit = context.watch<UserCubit>();
    final EvidenceCubit evidenceCubit = context.watch<EvidenceCubit>();

    if (locallyAuthenticated == false) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Xchange", style: Fonts.neueLight(50)),
                    ElevatedButton(
                      onPressed: () async => await biometricAuthenticate(),
                      child: Text("Login", style: Fonts.neueMedium(20)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    if (userCubit.state.credentials == null) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Xchange", style: Fonts.neueLight(50)),
                    ElevatedButton(
                      onPressed: () async {
                        final credentials = await auth0
                            .webAuthentication(scheme: "xchange")
                            .login(audience: "http://localhost:5230");

                        await userCubit.login(credentials, auth0);
                        await evidenceCubit
                            .initialise(userCubit.state.credentials);
                      },
                      child: Text("Login", style: Fonts.neueMedium(20)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    // if (userCubit.state.user == null) {
    // TODO account creation page
    // }

    if (userCubit.state.credentials.isAdmin()) {
      return BlocProvider(
        create: (_) => LimitsCubit(),
        child: const AdminPage(),
      );
    }

    if (evidenceCubit.state.evidenceRequest != null &&
        evidenceCubit.state.evidenceRequest?.status ==
            EvidenceRequestStatus.rejected) {
      return const BannedPage();
    }

    if (evidenceCubit.state.evidenceRequest != null &&
        evidenceCubit.state.evidenceRequest?.status ==
            EvidenceRequestStatus.active) {
      return const FrozenSubmissionPendingPage();
    }

    if (evidenceCubit.state.evidenceRequest != null &&
        evidenceCubit.state.evidenceRequest?.status ==
            EvidenceRequestStatus.waiting) {
      return const FrozenPage();
    }

    return BlocProvider(
      create: (_) => HomePageCubit(),
      child: const HomePage(),
    );
  }
}
