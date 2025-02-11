import 'dart:async';
import 'dart:collection';

import 'package:di/injection_container.dart';
import 'package:domain/repository/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/extensions/todo_domain_ui_extensions.dart';
import 'package:presentation/ui/model/todo.dart';

class _TodoTask {
  final int index;
  final String name;
  final Completer<void> completer;

  _TodoTask({
    required this.index,
    required this.name,
  }) : completer = Completer<void>();
}

class TodoListNotifier with ChangeNotifier {
  final TodoRepository todoRepository;

  var _pageId = 0;

  var _isEditMode = false;

  bool get isEditMode => _isEditMode;

  List<TodoUiModel> _todos = <TodoUiModel>[];

  List<TodoUiModel> get todos => UnmodifiableListView(_todos);

  final Queue<_TodoTask> _taskQueue = Queue();
  bool _isProcessing = false;

  bool get completeEvent => _completeEvent;
  bool _completeEvent = false;

  double get completeRate {
    final completeCount = todos.where((e) => e.completed == true).length;
    if (todos.isEmpty) return 0.0;
    return completeCount / todos.length;
  }

  TodoListNotifier({required this.todoRepository});

  TodoUiModel? getTodo(int index) {
    try {
      return todos[index];
    } catch (e) {
      return null;
    }
  }

  Future loadTodoList(int pageId, {bool notifyChanged = true}) async {
    if (pageId <= 0) return;

    _pageId = pageId;
    _todos = (await todoRepository.getTodosByPageId(pageId)).map(
      (e) {
        return e.toUiModel();
      },
    ).toList();
    print('todos= $_todos');
    if (notifyChanged) {
      notifyListeners();
    }
  }

  void addOrUpdateName(int index, String name) async {
    _taskQueue.add(_TodoTask(index: index, name: name));
    if (!_isProcessing) {
      _processQueue();
    }
  }

  void _processQueue() async {
    if (_isProcessing || _taskQueue.isEmpty) return;
    _isProcessing = true;

    while (_taskQueue.isNotEmpty) {
      final task = _taskQueue.removeFirst();
      final index = task.index;
      final name = task.name;

      TodoUiModel? todo;
      try {
        todo = _todos[index];
      } catch (e) {
        todo = null;
      }

      if (todo == null) {
        await todoRepository.createTodo(_pageId, name);
        await loadTodoList(_pageId, notifyChanged: false);
      } else {
        await updateName(todo.id, name);
      }

      task.completer.complete();
    }

    _isProcessing = false;
  }

  Future updateName(int? id, String name) async {
    if (id == null) return;

    final updated = await todoRepository.updateTodoWith(id, name: name);
    if (!updated) {
      loadTodoList(_pageId);
    }
  }

  void setCompleted(int index, bool completed) async {
    final todoId = _todos[index].id;

    final updated = await todoRepository.updateTodoWith(
      todoId,
      completed: completed,
    );
    if (updated) {
      await loadTodoList(_pageId);
      _completeEvent = _todos.every((todo) => todo.completed);
    }
  }

  void finishCompleteEvent() {
    _completeEvent = false;
  }

  void reorderTodos(int oldIndex, int newIndex) async {
    final item = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, item);

    await todoRepository.reorderTodos(_pageId, oldIndex, newIndex);
  }

  void deleteTodo(int index) async {
    final todo = _todos[index];
    _todos.removeAt(index);
    todoRepository.deleteTodo(todo.id);
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
