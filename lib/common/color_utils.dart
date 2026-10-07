import 'package:flutter/material.dart';

class ColorUtils {
  static Color getStatusBackGroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'cancelled':
        return Colors.red;

      case 'new':
        return const Color(0xFFafccff);
      case 'active':
        return const Color(0xFFd3fcd3);
      case 'inactive':
        return const Color(0xFFf9dada);
      case 'disable':
        return const Color(0xFFFFF0D3);
      default:
        return Colors.grey;
    }
  }
}