import 'package:di/injection_container.dart';
import 'package:domain/repository/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier with ChangeNotifier {
  final TodoRepository todoRepository;

  var _currentPageId = 1;

  HomeNotifier({required this.todoRepository});

  void loadTodoList() async {
    // final result = todoRepository.getTodosByPageId(_currentPageId);
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final homeProvider = ChangeNotifierProvider<HomeNotifier>(
  (ref) => HomeNotifier(todoRepository: getIt<TodoRepository>()),
);
