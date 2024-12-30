import 'package:domain/model/todo_model.dart';

abstract class TodoRepository {
  Future<TodoModel?> getTodo(int id);
}
