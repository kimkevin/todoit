import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/todos_table.dart';

part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(super.db);

  Future<int> _createTodo(TodosCompanion todo) => into(todos).insert(todo);

  Future<TodoTable?> getTodo(int id) =>
      (select(todos)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> updateTodo(TodosCompanion todo) => update(todos).replace(todo);

  Future<int> deleteTodo(int id) => (delete(todos)..where((t) => t.id.equals(id))).go();

  Future<int> createTodo(int pageId, TodosCompanion todo) => transaction(() async {
        try {
          // 1. 투두 생성
          final id = await _createTodo(todo);

          // 2. 페이지-투두 연결
          await db.pageTodosDao.createPageTodo(
            PageTodosCompanion(pageId: Value(pageId), todoId: Value(id)),
          );

          return id;
        } catch (e) {
          return 0;
        }
      });

  Future<List<TodoTable>> getAllTodo() =>
      (select(todos)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)]))
          .get();
}
