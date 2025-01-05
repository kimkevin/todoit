import 'package:data/datasource/todo_data_source.dart';
import 'package:data/model/entity/todo_entity.dart';
import 'package:local/database/database.dart';
import 'package:local/database/extensions/todo_companion_entity_extensions.dart';

class TodoDataSourceImpl extends TodoDataSource {
  final AppDatabase database;

  TodoDataSourceImpl({required this.database});

  @override
  Future<int> createTodo(int pageId, String name) async =>
      await database.todosDao.createTodo(pageId, TodoEntity(name: name).toCompanion());

  @override
  Future<TodoEntity?> getTodo(int id) async => (await database.todosDao.getTodo(id))?.toEntity();

  @override
  Future<bool> updateTodo(TodoEntity newTodo) async =>
      database.todosDao.updateTodo(newTodo.toCompanion());

  @override
  Future<int> deleteTodo(int id) => database.todosDao.deleteTodo(id);

  @override
  Future<List<TodoEntity>> getTodosByPageId(int pageId) async {
    List<int> todoIds = await database.pageTodosDao.getTodoIdsByPageId(pageId);
    List<Future> futures = [];

    for (final id in todoIds) {
      futures.add(database.todosDao.getTodo(id));
    }

    final todos = await Future.wait(
      futures,
    ).then((results) => results.whereType<TodoTable>().map((t) => t.toEntity()).toList());
    todos.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return todos;
  }

  @override
  Future<bool> reorderTodos(int oldIndex, int newIndex) =>
      database.todosDao.reorderTodos(oldIndex, newIndex);
}
