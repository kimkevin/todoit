import 'package:domain/model/todo_model.dart';

abstract class TodoRepository {
  Future<int> createTodo(int pageId, String name);

  Future<bool> updateTodo(TodoModel todoModel);

  Future<List<TodoModel>> getTodosByPageId(int pageId);

  Future<bool> reorderTodos(int oldIndex, int newIndex);

  Future<int> deleteTodo(int id);
}
