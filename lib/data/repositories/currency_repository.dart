import "dart:convert";

import "package:auth0_flutter/auth0_flutter.dart";
import "package:http/http.dart" as http;

import "../dtos/currency.dart";

class CurrencyRepository {
  static Future<List<Currency>> getCurrencies() async {
    final response = await http.get(
      Uri.http("10.0.2.2:5230", "currencies"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Currency.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  static Future<bool> setCurrencyLimit(String currencyId, double amount, Credentials? credentials) async {
    final response = await http.patch(
      Uri.http("10.0.2.2:5230", "currency/$currencyId/limit", {"amount": amount.toStringAsFixed(2)}),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${credentials?.accessToken}",
      },
    );

    return response.statusCode == 200;
  }
}
