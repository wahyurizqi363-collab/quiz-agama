import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../repositories/history_repository.dart';
import '../repositories/score_repository.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'result_view.dart';

class QuizView extends StatelessWidget {
  final Category category;

  const QuizView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => QuizViewModel(
        category,
        ctx.read<HistoryRepository>(),
        ctx.read<ScoreRepository>(),
        ctx.read<AuthViewModel>().user!,
      ),
      child: const _QuizBody(),
    );
  }
}

class _QuizBody extends StatelessWidget {
  const _QuizBody();

  Color? _optionColor(bool? state) {
    if (state == null) return null;
    return state ? Colors.green.shade100 : Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizViewModel>();
    final q = vm.currentQuestion;
    final warn = vm.isTimeWarning;

    return Scaffold(
      appBar: AppBar(title: Text(vm.category.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Soal ${vm.questionNumber} / ${vm.total}'),
                Row(children: [
                  const Icon(Icons.timer_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${vm.secondsLeft} dtk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: warn ? Colors.red : null,
                    ),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: vm.timeProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              color: warn ? Colors.red : null,
            ),
            const SizedBox(height: 24),
            Text(
              q.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < q.options.length; i++)
              Card(
                color: _optionColor(vm.optionState(i)),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    child: Text(String.fromCharCode(65 + i)),
                  ),
                  title: Text(q.options[i]),
                  onTap: () => vm.answer(i),
                ),
              ),
            const Spacer(),
            if (vm.isAnswered) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(vm.feedbackText),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final finished = await vm.next();
                  if (finished && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultView(
                          category: vm.category,
                          score: vm.score,
                          total: vm.total,
                          scoreSaved: !vm.syncFailed,
                        ),
                      ),
                    );
                  }
                },
                child: Text(vm.isLast ? 'Lihat Hasil' : 'Soal Berikutnya'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
