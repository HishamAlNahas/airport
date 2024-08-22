import 'package:flutter/material.dart';

colorStyle({bool isBold = false, Color color = Colors.white70}) {
  return TextStyle(color: color, fontWeight: isBold ? FontWeight.bold : null);
}
