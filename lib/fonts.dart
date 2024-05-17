import "package:flutter/material.dart";

class Fonts {
  static TextStyle neueBold(double size) {
    return TextStyle(
      fontFamily: "HelveticaNeueInterface",
      fontWeight: FontWeight.bold,
      fontSize: size,
    );
  }

  static TextStyle neueBoldItalic(double size) {
    return TextStyle(
      fontFamily: "HelveticaNeueInterface",
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: size,
    );
  }

  static TextStyle neueLight(double size) {
    return TextStyle(
      fontFamily: "HelveticaNeueInterface",
      fontWeight: FontWeight.w300,
      fontSize: size,
    );
  }

  static TextStyle neueLightItalic(double size) {
    return TextStyle(
      fontFamily: "HelveticaNeueInterface",
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.italic,
      fontSize: size,
    );
  }

  static TextStyle neueMedium(double size) {
    return TextStyle(
      fontFamily: "HelveticaNeueInterface",
      fontWeight: FontWeight.w500,
      fontSize: size,
    );
  }

  static TextStyle neueMediumItalic(double size) {
    return TextStyle(
      fontFamily: "HelveticaNeueInterface",
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      fontSize: size,
    );
  }
}