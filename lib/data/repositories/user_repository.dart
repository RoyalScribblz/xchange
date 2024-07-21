import "dart:convert";

import "package:auth0_flutter/auth0_flutter.dart";
import "package:http/http.dart" as http;

import "../contracts/get_user_response.dart";
import "../dtos/currency.dart";

class UserRepository {
  static Future<GetUserResponse?> getUser(Credentials? credentials) async {
    final response = await http.get(
      Uri.http("10.0.2.2:5230", "user"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${credentials?.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      return GetUserResponse.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<GetUserResponse?> createUser(Credentials? credentials) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "user"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${credentials?.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      return GetUserResponse.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<Currency?> setLocalCurrency(String currencyId, Credentials? credentials) async {
    final response = await http.patch(
      Uri.http(
        "10.0.2.2:5230",
        "user/localCurrency",
        {"currencyId": currencyId},
      ),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${credentials?.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      return Currency.fromJson(json.decode(response.body));
    }

    return null;
  }
}
