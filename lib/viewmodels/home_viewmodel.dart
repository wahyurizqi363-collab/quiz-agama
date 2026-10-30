import 'package:flutter/foundation.dart' hide Category;
import '../models/question.dart';
import '../repositories/question_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final QuestionRepository _repository;

  HomeViewModel(this._repository);

  List<Category> get categories => _repository.getCategories();
}
