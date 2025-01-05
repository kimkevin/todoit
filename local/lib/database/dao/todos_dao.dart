import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/todos_table.dart';

part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(super.db);

  Future<int> _createTodo(TodosCompanion todo) async {
    final maxOrderIndex = await _getMaxOrderIndex();

    todo = todo.copyWith(orderIndex: Value(maxOrderIndex + 1));

    final result = await into(todos).insert(todo);
    return result;
  }

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

  Future<bool> reorderTodos(int oldIndex, int newIndex) => transaction(() async {
        try {
          final list =
              await (select(todos)..orderBy([(e) => OrderingTerm(expression: e.orderIndex)])).get();
          final movedTodo = list.removeAt(oldIndex);
          list.insert(newIndex, movedTodo);

          for (int i = 0; i < list.length; i++) {
            await (update(todos)..where((e) => e.id.equals(list[i].id))).write(
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

  Future<int> _getMaxOrderIndex() async {
    final result = await (select(todos)
          ..orderBy([(e) => OrderingTerm(expression: e.orderIndex, mode: OrderingMode.desc)]))
        .get();

    return result.firstOrNull?.orderIndex ?? 0;
  }
}
