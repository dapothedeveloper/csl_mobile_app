import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get success => const Color(0xFF28a745);
  Color get info => const Color(0xFF17a2b8);
  Color get warning => const Color(0xFFffc107);
  Color get danger => const Color(0xFFdc3545);
  Color get primary => const Color.fromRGBO(252, 37, 86, 1);
  Color get accent => const Color.fromRGBO(29, 42, 56, 1);
}
