import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/todos_table.dart';

part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(super.db);

  Future<int> createTodo(TodosCompanion todo) => into(todos).insert(todo);

  Future<TodoTable> getTodo(int id) => (select(todos)..where((h) => h.id.equals(id))).getSingle();

  Future<bool> updateTodo(TodosCompanion todo) => update(todos).replace(todo);

  Future<int> deleteTodo(int id) => (delete(todos)..where((h) => h.id.equals(id))).go();
}
