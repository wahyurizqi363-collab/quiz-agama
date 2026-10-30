import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'history_view.dart';
import 'leaderboard_view.dart';
import 'quiz_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final auth = context.watch<AuthViewModel>();
    final user = auth.user;
    if (user == null) return const SizedBox.shrink(); // saat proses logout

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Agama Islam'),
        actions: [
          IconButton(
            tooltip: 'Peringkat',
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardView()),
            ),
          ),
          IconButton(
            tooltip: 'Riwayat skor',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryView()),
            ),
          ),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Halo, ${user.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (user.isAdmin) const Chip(label: Text('Admin')),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih bab quiz. Waktu menjawab ${QuizViewModel.secondsPerQuestion} detik per soal.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          for (final c in vm.categories)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(c.icon)),
                title: Text(c.name),
                subtitle: Text('${c.questions.length} soal'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuizView(category: c)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
