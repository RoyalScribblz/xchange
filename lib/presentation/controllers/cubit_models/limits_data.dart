import "package:flutter/material.dart";

import "../../../data/dtos/currency.dart";

class LimitsData {
  LimitsData(this.search, this.currencies, this.controllers);

  final String search;
  final List<Currency> currencies;
  final List<TextEditingController> controllers;
}