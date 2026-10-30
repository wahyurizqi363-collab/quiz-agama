/// Skor terbaik satu pengguna pada satu bab.
class ScoreEntry {
  final String id;
  final String uid;
  final String userName;
  final String category;
  final int score;
  final int total;
  final DateTime updatedAt;

  const ScoreEntry({
    required this.id,
    required this.uid,
    required this.userName,
    required this.category,
    required this.score,
    required this.total,
    required this.updatedAt,
  });
}
