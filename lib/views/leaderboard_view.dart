import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/question_repository.dart';
import '../repositories/score_repository.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/leaderboard_viewmodel.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => LeaderboardViewModel(
        ctx.read<ScoreRepository>(),
        ctx.read<AuthViewModel>().user!,
        ctx.read<QuestionRepository>().getCategories().map((c) => c.name).toList(),
      ),
      child: const _LeaderboardBody(),
    );
  }
}

class _LeaderboardBody extends StatelessWidget {
  const _LeaderboardBody();

  Color? _rankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.blueGrey.shade200;
      case 3:
        return Colors.brown.shade300;
      default:
        return null;
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    LeaderboardViewModel vm,
    RankRow row,
  ) async {
    final all = vm.filter == LeaderboardViewModel.allCategories;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus dari peringkat?'),
        content: Text(all
            ? 'Semua skor milik "${row.name}" akan dihapus.'
            : 'Skor "${row.name}" pada bab ${vm.filter} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) vm.deleteRow(row);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LeaderboardViewModel>();
    final rows = vm.rows;

    return Scaffold(
      appBar: AppBar(title: const Text('Peringkat')),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                for (final f in vm.filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: vm.filter == f,
                      onSelected: (_) => vm.setFilter(f),
                    ),
                  ),
              ],
            ),
          ),
          if (vm.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                vm.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: vm.loading
                ? const Center(child: CircularProgressIndicator())
                : rows.isEmpty
                    ? const Center(child: Text('Belum ada skor.'))
                    : ListView.separated(
                        itemCount: rows.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final r = rows[i];
                          final isMe = r.uid == vm.currentUser.uid;
                          return ListTile(
                            tileColor: isMe ? Colors.teal.shade50 : null,
                            leading: CircleAvatar(
                              backgroundColor: _rankColor(r.rank),
                              child: Text('${r.rank}'),
                            ),
                            title: Text(isMe ? '${r.name} (kamu)' : r.name),
                            subtitle: Text('${r.score} dari ${r.total} benar'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${r.score}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (vm.isAdmin)
                                  IconButton(
                                    tooltip: 'Hapus (admin)',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () =>
                                        _confirmDelete(context, vm, r),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
