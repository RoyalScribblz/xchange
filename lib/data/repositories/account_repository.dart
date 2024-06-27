import "dart:convert";

import "../contracts/get_accounts_response.dart";
import "package:http/http.dart" as http;

import "../contracts/pending_exchange.dart";

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

  static Future<GetAccountsResponse?> deposit(
      String accountId, double amount) async {
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

  static Future<GetAccountsResponse?> withdraw(
      String accountId, double amount) async {
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

  static Future<GetAccountsResponse?> create(
      String userId, String currencyId) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "create", {
        "userId": userId,
        "currencyId": currencyId,
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

  static Future<PendingExchange?> createExchange(String userId, double amount,
      String fromCurrencyId, String toCurrencyId) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "/exchange/create", {
        "userId": userId,
        "amount": amount.toString(),
        "fromCurrencyId": fromCurrencyId,
        "toCurrencyId": toCurrencyId
      }),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return PendingExchange.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<List<GetAccountsResponse>> completeExchange(
      String userId, String pendingExchangeId) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "exchange/complete/$pendingExchangeId", {
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
}
