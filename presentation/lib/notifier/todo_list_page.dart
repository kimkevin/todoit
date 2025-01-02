import 'dart:collection';

import 'package:di/injection_container.dart';
import 'package:domain/repository/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/extensions/todo_domain_ui_extensions.dart';
import 'package:presentation/ui/model/todo.dart';

class TodoListNotifier with ChangeNotifier {
  final TodoRepository todoRepository;

  var _pageId = 0;

  List<TodoUiModel> _todos = <TodoUiModel>[];
  List<TodoUiModel> get todos => UnmodifiableListView(_todos);

  TodoListNotifier({required this.todoRepository});

  void loadTodoList(int pageId) async {
    if (pageId <= 0) return;

    _pageId = pageId;
    _todos = (await todoRepository.getTodosByPageId(pageId)).map((e) => e.toUiModel()).toList();
    print('todos= $_todos');
    notifyListeners();
  }

  void addTodo(String name) async {
    await todoRepository.createTodo(_pageId, name);
    loadTodoList(_pageId);
  }

  void toggleTodo(TodoUiModel todo) async {
    final newTodo = todo.copyWith(completed: !todo.completed);
    final result = await todoRepository.updateTodo(newTodo.toModel());
    if (result) {
      loadTodoList(_pageId);
    }
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final todoListProvider = ChangeNotifierProvider<TodoListNotifier>(
  (ref) => TodoListNotifier(todoRepository: getIt<TodoRepository>()),
);
