import 'package:flutter/material.dart';
import '../models/question.dart';
import 'leaderboard_view.dart';
import 'quiz_view.dart';

class ResultView extends StatelessWidget {
  final Category category;
  final int score;
  final int total;
  final bool scoreSaved;

  const ResultView({
    super.key,
    required this.category,
    required this.score,
    required this.total,
    this.scoreSaved = true,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).round();
    final message = percent >= 80
        ? 'Masya Allah, luar biasa!'
        : percent >= 60
            ? 'Bagus, terus belajar!'
            : 'Ayo belajar lagi, kamu pasti bisa!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.name, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text(
                '$score / $total',
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
              ),
              Text('$percent%', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              if (!scoreSaved) ...[
                const SizedBox(height: 12),
                Text(
                  'Skor belum masuk peringkat (periksa koneksi internet).',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange.shade800),
                ),
              ],
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.leaderboard),
                label: const Text('Lihat Peringkat'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardView()),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Ulangi'),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => QuizView(category: category)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Beranda'),
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
