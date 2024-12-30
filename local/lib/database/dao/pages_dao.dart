import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/pages_table.dart';
import 'package:local/exceptions/basic_page_deletion_exception.dart';

part 'pages_dao.g.dart';

@DriftAccessor(tables: [Pages])
class PagesDao extends DatabaseAccessor<AppDatabase> with _$PagesDaoMixin {
  PagesDao(super.db);

  Future<int> createPage(PagesCompanion page) => into(pages).insert(page);

  Future<PageTable?> getPage(int id) =>
      (select(pages)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<bool> updatePage(PagesCompanion page) => update(pages).replace(page);

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
}
