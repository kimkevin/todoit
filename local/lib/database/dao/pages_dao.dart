import 'package:data/model/entity/page_entity.dart';
import 'package:data/model/entity/todo_entity.dart';
import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/extensions/page_companion_entity_extensions.dart';
import 'package:local/database/extensions/todo_companion_entity_extensions.dart';
import 'package:local/database/models/pages_table.dart';
import 'package:local/exceptions/basic_page_deletion_exception.dart';

part 'pages_dao.g.dart';

@DriftAccessor(tables: [Pages])
class PagesDao extends DatabaseAccessor<AppDatabase> with _$PagesDaoMixin {
  PagesDao(super.db);

  Future<int> createPage(PagesCompanion page) async {
    final minOrderIndex = await _getMinOrderIndex();

    page = page.copyWith(orderIndex: Value(minOrderIndex - 1));

    final result = await into(pages).insert(page);
    return result;
  }

  Future<PageTable?> getPage(int id) =>
      (select(pages)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<bool> updatePage(PagesCompanion page) => update(pages).replace(page);

  Future<List<PageTable>> getAllPage() => (select(pages)
        ..orderBy([(t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.asc)]))
      .get();

  Future<int> _deletePage(int id) {
    if (id == 1) {
      throw BasicPageDeletionException();
    }
    return (delete(pages)..where((p) => p.id.equals(id))).go();
  }

  Future<bool> deletePageAndTodos(int id) => transaction(() async {
        try {
          // 1. 페이지에 연관된 모든  투두 삭제
          final todoIds = await db.pageTodosDao.getTodoIdsByPageId(id);
          if (todoIds.isNotEmpty) {
            List<Future> deleteFutures = [];
            for (var id in todoIds) {
              deleteFutures.add(db.todosDao.deleteTodo(id));
            }
            await Future.wait(deleteFutures);
          }

          // 2. 페이지 삭제
          await _deletePage(id);
          return true;
        } catch (e) {
          return false;
        }
      });

  Future<int> _getMinOrderIndex() async {
    final result = await (select(pages)
          ..orderBy([(e) => OrderingTerm(expression: e.orderIndex, mode: OrderingMode.asc)]))
        .get();

    return result.firstOrNull?.orderIndex ?? 0;
  }

  Future<bool> reorderTodos(int oldIndex, int newIndex) => transaction(() async {
        try {
          final list =
              await (select(pages)..orderBy([(e) => OrderingTerm(expression: e.orderIndex)])).get();
          final movedPage = list.removeAt(oldIndex);
          list.insert(newIndex, movedPage);

          for (int i = 0; i < list.length; i++) {
            await (update(pages)..where((e) => e.id.equals(list[i].id))).write(
              PagesCompanion(
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

  Future<bool> createPageTodos(String name, List<String> todoNames) => transaction(() async {
        try {
          final pageId = await createPage(PageEntity(name: name).toCompanion());
          final todos = todoNames.map((e) => TodoEntity(name: e));
          List<Future> todoFutures = [];
          for (final todo in todos) {
            todoFutures.add(db.todosDao.createTodo(pageId, todo.toCompanion()));
          }
          await Future.wait(todoFutures);
          return true;
        } catch (e) {
          return false;
        }
      });
}
