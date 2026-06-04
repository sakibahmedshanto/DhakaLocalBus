import 'dart:convert';
import 'package:flutter/services.dart';

class BusChangeData {
  static Map<String, List<String>>? _busRoutes;

  static Future<void> init() async {
    if (_busRoutes != null) return;
    final raw = await rootBundle.loadString('assets/data/bus_change_data.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _busRoutes = decoded.map((k, v) => MapEntry(k, List<String>.from(v as List)));
  }

  static Map<String, List<String>> get busRoutes => _busRoutes ?? {};
}
