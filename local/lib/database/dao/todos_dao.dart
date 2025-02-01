import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/todos_table.dart';

part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(super.db);

  Future<int> _createTodo(TodosCompanion todo) => into(todos).insert(todo);

  Future<Todo?> getTodo(int id) => (select(todos)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> updateTodo(TodosCompanion todo) => update(todos).replace(todo);

  Future<int> deleteTodo(int id) => (delete(todos)..where((t) => t.id.equals(id))).go();

  Future<int> createTodo(TodosCompanion todo) => transaction(() async {
        try {
          int pageId = todo.pageId.value;
          final int? maxOrderIndex = await _getTodoMaxOrderIndexOfPage(pageId);
          final newTodo = todo.copyWith(
            pageId: Value(pageId),
            orderIndex: Value(maxOrderIndex == null ? 0 : maxOrderIndex + 1),
          );
          return await _createTodo(newTodo);
        } catch (e) {
          return 0;
        }
      });

  Future<List<Todo>> getTodosByPageId(int pageId) => (select(todos)
        ..where((t) => t.pageId.equals(pageId))
        ..orderBy([(e) => OrderingTerm(expression: e.orderIndex)]))
      .get();

  Future<bool> reorderTodos(
    int pageId,
    int oldIndex,
    int newIndex,
  ) =>
      transaction(() async {
        try {
          final list = await (select(todos)
                ..where((e) => e.pageId.equals(pageId))
                ..orderBy([(e) => OrderingTerm(expression: e.orderIndex)]))
              .get();
          final movedTodo = list.removeAt(oldIndex);
          list.insert(newIndex, movedTodo);

          for (int i = 0; i < list.length; i++) {
            await (update(db.todos)
                  ..where(
                    (e) => e.id.equals(list[i].id),
                  ))
                .write(
              TodosCompanion(
                orderIndex: Value(i),
                updatedAt: Value(DateTime.now()),
              ),
            );
          }
          return true;
        } catch (e) {
          return false;
        }
      });

  Future<int?> _getTodoMaxOrderIndexOfPage(int pageId) async => (await (select(todos)
            ..where((tbl) => tbl.pageId.equals(pageId))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.orderIndex, mode: OrderingMode.desc)]))
          .map((row) => row.orderIndex)
          .get())
      .firstOrNull;
}
