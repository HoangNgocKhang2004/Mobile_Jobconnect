import 'package:flutter/widgets.dart';

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  bool isSelected;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.isSelected,
  });
}