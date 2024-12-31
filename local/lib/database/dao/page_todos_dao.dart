import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/page_todos_table.dart';

part 'page_todos_dao.g.dart';

@DriftAccessor(tables: [PageTodos])
class PageTodosDao extends DatabaseAccessor<AppDatabase> with _$PageTodosDaoMixin {
  PageTodosDao(super.db);

  Future<int> createPageTodo(PageTodosCompanion pageTodo) => into(pageTodos).insert(pageTodo);

  Future<List<int>> getTodoIdsByPageId(int pageId) async {
    final result = select(pageTodos)
      ..where((pt) => pt.pageId.equals(pageId))
      ..orderBy([(t) => OrderingTerm(expression: t.todoId, mode: OrderingMode.desc)]);
    return (await result.get()).map((pt) => pt.todoId).toList();
  }

  Future<List<PageTodoTable>> getAllPageTodo() => (select(pageTodos)
        ..orderBy([(t) => OrderingTerm(expression: t.todoId, mode: OrderingMode.desc)]))
      .get();

  Future<int> deletePageTodosByPageId(int pageId) =>
      (delete(pageTodos)..where((pt) => pt.pageId.equals(pageId))).go();

  Future<int> deletePageTodoByTodoId(int todoId) =>
      (delete(pageTodos)..where((pt) => pt.todoId.equals(todoId))).go();
}
