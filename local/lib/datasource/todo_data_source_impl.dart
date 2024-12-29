import 'package:data/datasource/todo_data_source.dart';
import 'package:data/model/entity/todo_entity.dart';
import 'package:local/database/database.dart';
import 'package:local/database/extensions/todo_entity_companion_extensions.dart';

class TodoDataSourceImpl extends TodoDataSource {
  final AppDatabase database;

  TodoDataSourceImpl({required this.database});

  @override
  Future<int> createTodo(String title) async =>
      await database.todosDao.createTodo(TodoEntity(name: title).toCompanion());

  @override
  Future<TodoEntity> getTodo(int id) async => (await database.todosDao.getTodo(id)).toEntity();

  @override
  Future<bool> updateTodo(int id, String name, bool completed) async {
    final newTodo = TodoEntity(id: id, name: name, completed: completed);
    final result = await database.todosDao.updateTodo(newTodo.toCompanion());
    return result;
  }

  @override
  Future<bool> deleteTodo(int id) async {
    final result = await database.todosDao.deleteTodo(id);
    return result > 0;
  }
}
