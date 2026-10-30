import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import '../models/app_user.dart';
import '../models/history_item.dart';
import '../models/question.dart';
import '../repositories/history_repository.dart';
import '../repositories/score_repository.dart';

class QuizViewModel extends ChangeNotifier {
  static const int secondsPerQuestion = 20;
  static const int warningSeconds = 5;

  final Category category;
  final HistoryRepository _history;
  final ScoreRepository _scores;
  final AppUser user;

  late final List<Question> _questions;
  int _index = 0;
  int _score = 0;
  int? _selected; // null = belum menjawab, -1 = waktu habis
  int _secondsLeft = secondsPerQuestion;
  Timer? _timer;
  bool _finishing = false;
  bool _syncFailed = false;

  QuizViewModel(this.category, this._history, this._scores, this.user) {
    _questions = List.of(category.questions)..shuffle();
    _startTimer();
  }

  // ---------- State untuk View ----------
  Question get currentQuestion => _questions[_index];
  int get questionNumber => _index + 1;
  int get total => _questions.length;
  int get score => _score;
  int? get selected => _selected;
  int get secondsLeft => _secondsLeft;
  bool get isAnswered => _selected != null;
  bool get isTimeUp => _selected == -1;
  bool get isCorrect => _selected == currentQuestion.answer;
  bool get isLast => _index == _questions.length - 1;
  bool get isTimeWarning => _secondsLeft <= warningSeconds;
  double get timeProgress => _secondsLeft / secondsPerQuestion;
  bool get syncFailed => _syncFailed;

  /// true = benar, false = salah dipilih, null = netral.
  bool? optionState(int i) {
    if (!isAnswered) return null;
    if (i == currentQuestion.answer) return true;
    if (i == _selected) return false;
    return null;
  }

  String get feedbackText {
    final prefix = isTimeUp
        ? 'Waktu habis! '
        : isCorrect
            ? 'Benar! '
            : 'Kurang tepat. ';
    return '$prefix${currentQuestion.explanation}';
  }

  // ---------- Aksi dari View ----------
  void answer(int i) {
    if (isAnswered) return;
    _timer?.cancel();
    _selected = i;
    if (i == currentQuestion.answer) _score++;
    notifyListeners();
  }

  /// Return true jika quiz selesai (riwayat & peringkat sudah diproses).
  Future<bool> next() async {
    if (!isLast) {
      _index++;
      _selected = null;
      _startTimer();
      notifyListeners();
      return false;
    }

    if (_finishing) return false; // cegah tekan dua kali
    _finishing = true;

    await _history.add(
      user.uid,
      HistoryItem(
        category: category.name,
        score: _score,
        total: total,
        date: DateTime.now(),
      ),
    );

    try {
      await _scores.submitBest(user, category.name, _score, total);
    } catch (_) {
      _syncFailed = true; // riwayat lokal tetap tersimpan
    }
    return true;
  }

  // ---------- Timer ----------
  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _secondsLeft--;
      if (_secondsLeft <= 0) {
        _secondsLeft = 0;
        _selected = -1; // waktu habis
        t.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
