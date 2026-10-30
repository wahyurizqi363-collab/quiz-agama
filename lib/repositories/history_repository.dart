import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryRepository {
  String _key(String uid) => 'quiz_history_$uid';

  /// Terbaru di urutan paling atas.
  Future<List<HistoryItem>> getAll(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key(uid)) ?? [];
    return raw
        .map((e) => HistoryItem.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> add(String uid, HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key(uid)) ?? [];
    raw.add(jsonEncode(item.toJson()));
    await prefs.setStringList(_key(uid), raw);
  }

  Future<void> clear(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(uid));
  }
}
