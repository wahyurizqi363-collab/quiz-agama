import '../data/question_data.dart';
import '../models/question.dart';

/// Sumber data soal. Nanti bisa diganti ke JSON / Firebase / API
/// tanpa mengubah ViewModel maupun View.
class QuestionRepository {
  List<Category> getCategories() => kCategories;
}
