import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:di/injection_container.dart';
import 'package:domain/repository/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/extensions/todo_domain_ui_extensions.dart';
import 'package:presentation/ui/model/todo.dart';

class TodoListNotifier with ChangeNotifier {
  final TodoRepository todoRepository;

  var _pageId = 0;

  var _isEditMode = false;

  bool get isEditMode => _isEditMode;

  List<TodoUiModel> _todos = <TodoUiModel>[];

  List<TodoUiModel> get todos => UnmodifiableListView(_todos);

  double get completeRate {
    final completeCount = todos.where((e) => e.completed).length;
    if (todos.isEmpty) return 0.0;
    return completeCount / todos.length;
  }

  TodoListNotifier({required this.todoRepository});

  void loadTodoList(int pageId) async {
    if (pageId <= 0) return;

    _pageId = pageId;
    _todos = (await todoRepository.getTodosByPageId(pageId)).map(
      (e) {
        return e.toUiModel();
      },
    ).toList();
    print('todos= $_todos');
    notifyListeners();
  }

  Future<int> addTodo(String name) => todoRepository.createTodo(_pageId, name);

  void updateName(int id, String name) async {
    final updated = await todoRepository.updateTodoName(id, name);
    // 이름은 스테이트풀하게 관리하고 있음
    if (!updated) {
      loadTodoList(_pageId);
    }
  }

  void toggleTodo(TodoUiModel todo) async {
    final updated = await todoRepository.updateTodoCompleted(todo.id, !todo.completed);
    if (updated) {
      loadTodoList(_pageId);
    }
  }

  void reorderTodos(int oldIndex, int newIndex) async {
    // UI 먼저 보여줌
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, item);
    notifyListeners();

    await todoRepository.reorderTodos(oldIndex, newIndex);
    loadTodoList(_pageId);
  }

  void deleteTodo(int id) async {
    await todoRepository.deleteTodo(id);
    loadTodoList(_pageId);
  }

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final todoListProvider = ChangeNotifierProvider.autoDispose<TodoListNotifier>(
  (ref) => TodoListNotifier(todoRepository: getIt<TodoRepository>()),
);
