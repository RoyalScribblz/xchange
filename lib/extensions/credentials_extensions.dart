import "package:auth0_flutter/auth0_flutter.dart";

extension CredentialsExtensions on Credentials? {
  /// Checks a credentials claims for the microsoft role claim and returns whether or not "Admin" is included.
  bool isAdmin() {
    if (this == null) {
      return false;
    }

    final List<dynamic> roles = this!.user.customClaims?[
            "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"]
        as List<dynamic>;

    return roles.contains("Admin");
  }
}
