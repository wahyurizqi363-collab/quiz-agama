class HistoryItem {
  final String category;
  final int score;
  final int total;
  final DateTime date;

  const HistoryItem({
    required this.category,
    required this.score,
    required this.total,
    required this.date,
  });

  int get percent => (score / total * 100).round();

  Map<String, dynamic> toJson() => {
        'category': category,
        'score': score,
        'total': total,
        'date': date.toIso8601String(),
      };

  factory HistoryItem.fromJson(Map<String, dynamic> j) => HistoryItem(
        category: j['category'],
        score: j['score'],
        total: j['total'],
        date: DateTime.parse(j['date']),
      );
}
