import "package:auth0_flutter/auth0_flutter.dart";

import "../../../data/contracts/get_user_response.dart";

class User {
  User(
    this.credentials,
    this.user,
  );

  final Credentials? credentials;
  final GetUserResponse? user;
}
