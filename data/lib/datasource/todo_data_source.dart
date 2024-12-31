import 'package:data/model/entity/todo_entity.dart';

abstract class TodoDataSource {
  Future<int> createTodo(int pageId, String name);

  Future<TodoEntity?> getTodo(int id);

  Future<bool> updateTodo(int id, String name, bool isCompleted);

  Future<int> deleteTodo(int id);

  Future<List<TodoEntity>> getTodosByPageId(int pageId);
}
