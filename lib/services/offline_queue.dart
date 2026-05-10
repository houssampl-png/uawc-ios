import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/offline_operation.dart';

class OfflineQueue {
  static const _key = 'offline_operations';

  Future<void> add(String type, Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    final op = OfflineOperation(type: type, payload: payload, createdAt: DateTime.now());
    current.add(jsonEncode(op.toJson()));
    await prefs.setStringList(_key, current);
  }

  Future<List<OfflineOperation>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    return current.map((e) => OfflineOperation.fromJson(jsonDecode(e))).toList();
  }

  Future<int> count() async => (await list()).length;

  Future<void> sync(ApiService api) async {
    final prefs = await SharedPreferences.getInstance();
    final operations = await list();
    final failed = <String>[];

    for (final op in operations) {
      try {
        if (op.type == 'create_person') {
          await api.createPerson(op.payload);
        } else if (op.type == 'confirm_receive') {
          await api.confirmReceive(op.payload);
        }
      } catch (_) {
        failed.add(jsonEncode(op.toJson()));
      }
    }

    await prefs.setStringList(_key, failed);
  }
}
