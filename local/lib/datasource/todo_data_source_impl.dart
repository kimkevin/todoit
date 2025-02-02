import 'package:data/datasource/todo_data_source.dart';
import 'package:data/model/entity/todo_entity.dart';
import 'package:local/database/database.dart';
import 'package:local/database/extensions/todo_companion_entity_extensions.dart';

class TodoDataSourceImpl extends TodoDataSource {
  final AppDatabase database;

  TodoDataSourceImpl({required this.database});

  @override
  Future<int> createTodo(int pageId, String name) => database.todosDao.createTodo(
        TodoEntity(
          pageId: pageId,
          name: name,
        ).toCompanion(),
      );

  @override
  Future<TodoEntity?> getTodo(int id) async => (await database.todosDao.getTodo(id))?.toEntity();

  @override
  Future<int> deleteTodo(int id) => database.todosDao.deleteTodo(id);

  @override
  Future<List<TodoEntity>> getTodosByPageId(int pageId) async =>
      (await database.todosDao.getTodosByPageId(pageId))
          .map(
            (t) => t.toEntity(),
          )
          .toList();

  @override
  Future<bool> reorderTodos(int pageId, int oldIndex, int newIndex) =>
      database.todosDao.reorderTodos(pageId, oldIndex, newIndex);

  @override
  Future<bool> updateTodoWith(int id, {String? name, bool? completed}) =>
      database.todosDao.updateTodoWith(id, name: name, completed: completed);
}
