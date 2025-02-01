import 'package:data/model/entity/todo_entity.dart';

abstract class TodoDataSource {
  Future<int> createTodo(int pageId, String name);

  Future<TodoEntity?> getTodo(int id);

  Future<bool> updateTodo(TodoEntity newTodo);

  Future<int> deleteTodo(int id);

  Future<List<TodoEntity>> getTodosByPageId(int pageId);

  Future<bool> reorderTodos(int pageId, int oldIndex, int newIndex);

  Future<bool> updateTodoName(int id, String name);

  Future<bool> updateTodoCompleted(int id, bool completed);
}
