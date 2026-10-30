import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import '../models/app_user.dart';
import '../models/score_entry.dart';
import '../repositories/score_repository.dart';

class RankRow {
  final int rank;
  final String uid;
  final String name;
  final int score;
  final int total;
  final String? entryId; // null pada tampilan "Semua bab"

  const RankRow({
    required this.rank,
    required this.uid,
    required this.name,
    required this.score,
    required this.total,
    this.entryId,
  });

  RankRow withRank(int r) => RankRow(
        rank: r,
        uid: uid,
        name: name,
        score: score,
        total: total,
        entryId: entryId,
      );
}

class LeaderboardViewModel extends ChangeNotifier {
  static const String allCategories = 'Semua bab';

  final ScoreRepository _repo;
  final AppUser currentUser;
  final List<String> _categoryNames;
  StreamSubscription<List<ScoreEntry>>? _sub;

  List<ScoreEntry> _entries = [];
  bool _loading = true;
  String? _error;
  String _filter = allCategories;

  LeaderboardViewModel(this._repo, this.currentUser, this._categoryNames) {
    _sub = _repo.watchAll().listen(
      (data) {
        _entries = data;
        _loading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Gagal memuat peringkat: $e';
        _loading = false;
        notifyListeners();
      },
    );
  }

  bool get loading => _loading;
  String? get error => _error;
  String get filter => _filter;
  bool get isAdmin => currentUser.isAdmin;
  List<String> get filters => [allCategories, ..._categoryNames];

  void setFilter(String f) {
    _filter = f;
    notifyListeners();
  }

  List<RankRow> get rows {
    if (_filter == allCategories) {
      final scores = <String, int>{};
      final totals = <String, int>{};
      final names = <String, String>{};
      for (final e in _entries) {
        scores[e.uid] = (scores[e.uid] ?? 0) + e.score;
        totals[e.uid] = (totals[e.uid] ?? 0) + e.total;
        names[e.uid] = e.userName;
      }
      final list = scores.keys
          .map((uid) => RankRow(
                rank: 0,
                uid: uid,
                name: names[uid]!,
                score: scores[uid]!,
                total: totals[uid]!,
              ))
          .toList()
        ..sort((a, b) {
          final byScore = b.score.compareTo(a.score);
          return byScore != 0
              ? byScore
              : a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      return _assignRanks(list);
    }

    final filtered = _entries.where((e) => e.category == _filter).toList()
      ..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        return byScore != 0 ? byScore : a.updatedAt.compareTo(b.updatedAt);
      });
    return _assignRanks(filtered
        .map((e) => RankRow(
              rank: 0,
              uid: e.uid,
              name: e.userName,
              score: e.score,
              total: e.total,
              entryId: e.id,
            ))
        .toList());
  }

  /// Skor sama = peringkat sama.
  List<RankRow> _assignRanks(List<RankRow> sorted) {
    final result = <RankRow>[];
    for (int i = 0; i < sorted.length; i++) {
      final rank = (i > 0 && sorted[i].score == sorted[i - 1].score)
          ? result[i - 1].rank
          : i + 1;
      result.add(sorted[i].withRank(rank));
    }
    return result;
  }

  /// Khusus admin.
  Future<void> deleteRow(RankRow row) async {
    if (!isAdmin) return;
    try {
      if (_filter == allCategories) {
        await _repo.deleteAllOfUser(row.uid);
      } else {
        await _repo.deleteEntry(row.entryId!);
      }
      _error = null;
    } catch (e) {
      _error = 'Gagal menghapus: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
