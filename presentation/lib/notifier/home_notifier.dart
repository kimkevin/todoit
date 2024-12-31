import 'dart:collection';

import 'package:di/injection_container.dart';
import 'package:domain/repository/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/extensions/todo_domain_ui_extensions.dart';
import 'package:presentation/ui/model/todo.dart';

class HomeNotifier with ChangeNotifier {
  final TodoRepository todoRepository;

  final _currentPageId = 1;

  List<Todo> _todos = <Todo>[];
  List<Todo> get todos => UnmodifiableListView(_todos);

  HomeNotifier({required this.todoRepository});

  void loadTodoList() async {
    _todos =
        (await todoRepository.getTodosByPageId(_currentPageId)).map((e) => e.toUiModel()).toList();
    print('todos= $_todos');
    notifyListeners();
  }

  void addTodo(String name) async {
    await todoRepository.createTodo(_currentPageId, name);
    loadTodoList();
  }

  void toggleTodo(Todo todo) async {
    final newTodo = todo.copyWith(completed: !todo.completed);
    final result = await todoRepository.updateTodo(newTodo.toModel());
    if (result) {
      loadTodoList();
    }
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final homeProvider = ChangeNotifierProvider<HomeNotifier>(
  (ref) => HomeNotifier(todoRepository: getIt<TodoRepository>()),
);
