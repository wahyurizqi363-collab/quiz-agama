import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/history_repository.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => HistoryViewModel(
        ctx.read<HistoryRepository>(),
        ctx.read<AuthViewModel>().user!.uid,
      )..load(),
      child: const _HistoryBody(),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  Future<void> _confirmClear(BuildContext context, HistoryViewModel vm) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus riwayat?'),
        content: const Text('Semua riwayat skor akan dihapus.'),
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
    if (ok == true) vm.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Skor'),
        actions: [
          IconButton(
            tooltip: 'Hapus semua',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmClear(context, vm),
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.isEmpty
              ? const Center(child: Text('Belum ada riwayat.'))
              : ListView.separated(
                  itemCount: vm.items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final h = vm.items[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${h.percent}%')),
                      title: Text(h.category),
                      subtitle: Text(vm.formatDate(h.date)),
                      trailing: Text(
                        '${h.score}/${h.total}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
    );
  }
}
