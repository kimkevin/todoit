import 'package:data/model/entity/todo_entity.dart';

abstract class TodoDataSource {
  Future<int> createTodo(int pageId, String title);

  Future<TodoEntity?> getTodo(int id);

  Future<bool> updateTodo(int id, String title, bool isCompleted);

  Future<int> deleteTodo(int id);
}
