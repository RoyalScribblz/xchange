import "dart:convert";

import "package:http/http.dart" as http;

import "../contracts/get_user_response.dart";
import "../dtos/currency.dart";

class UserRepository {
  static Future<GetUserResponse?> getUser(String userId) async {
    final response = await http.get(
      Uri.http("10.0.2.2:5230", "user/$userId"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return GetUserResponse.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<GetUserResponse?> createUser(String userId) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "user", {"userId": userId}),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return GetUserResponse.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<Currency?> setLocalCurrency(String userId, String currencyId) async {
    final response = await http.patch(
      Uri.http(
        "10.0.2.2:5230",
        "user/$userId/localCurrency",
        {"currencyId": currencyId},
      ),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return Currency.fromJson(json.decode(response.body));
    }

    return null;
  }
}
