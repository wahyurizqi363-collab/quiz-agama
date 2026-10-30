import 'package:flutter/foundation.dart' hide Category;
import '../models/history_item.dart';
import '../repositories/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository _repository;
  final String _uid;

  HistoryViewModel(this._repository, this._uid);

  List<HistoryItem> _items = [];
  bool _isLoading = true;

  List<HistoryItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isEmpty => _items.isEmpty;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await _repository.getAll(_uid);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clear() async {
    await _repository.clear(_uid);
    await load();
  }

  String formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }
}
