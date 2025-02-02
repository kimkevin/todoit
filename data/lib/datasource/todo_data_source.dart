import 'package:data/model/entity/todo_entity.dart';

abstract class TodoDataSource {
  Future<int> createTodo(int pageId, String name);

  Future<TodoEntity?> getTodo(int id);

  Future<int> deleteTodo(int id);

  Future<List<TodoEntity>> getTodosByPageId(int pageId);

  Future<bool> reorderTodos(int pageId, int oldIndex, int newIndex);

  Future<bool> updateTodoWith(int id, {String? name, bool? completed});
}
