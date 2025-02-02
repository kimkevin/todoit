import 'package:domain/model/todo_model.dart';

abstract class TodoRepository {
  Future<int> createTodo(int pageId, String name);

  Future<bool> updateTodoWith(int id, {String? name, bool? completed});

  Future<List<TodoModel>> getTodosByPageId(int pageId);

  Future<bool> reorderTodos(int pageId, int oldIndex, int newIndex);

  Future<int> deleteTodo(int id);
}
