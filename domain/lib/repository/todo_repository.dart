import 'package:domain/model/todo_model.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> getTodosByPageId(int pageId);

  Future<TodoModel?> getTodo(int id);
}
