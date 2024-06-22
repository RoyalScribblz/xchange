import "dart:convert";

import "../contracts/get_accounts_response.dart";
import "package:http/http.dart" as http;

class AccountRepository {
  static Future<List<GetAccountsResponse>> getAccounts(String userId) async {
    final response = await http.get(
      Uri.http("10.0.2.2:5230", "accounts", {
        "userId": userId,
      }),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map(
              (e) => GetAccountsResponse.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  static Future<GetAccountsResponse?> deposit(String accountId, double amount) async {
    final response = await http.patch(
      Uri.http("10.0.2.2:5230", "account/$accountId/deposit", {
        "amount": amount.toString(),
      }),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return GetAccountsResponse.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<GetAccountsResponse?> withdraw(String accountId, double amount) async {
    final response = await http.patch(
      Uri.http("10.0.2.2:5230", "account/$accountId/withdraw", {
        "amount": amount.toString(),
      }),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return GetAccountsResponse.fromJson(json.decode(response.body));
    }

    return null;
  }
}
