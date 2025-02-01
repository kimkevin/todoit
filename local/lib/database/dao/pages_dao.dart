import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/pages_table.dart';

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

  Future<Page?> getPage(int id) => (select(pages)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<bool> updatePage(PagesCompanion page) => update(pages).replace(page);

  Future<List<Page>> getAllPage() => (select(pages)
        ..orderBy([(t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.asc)]))
      .get();

  Future<bool> deletePage(int id) async {
    final result = await (delete(pages)..where((p) => p.id.equals(id))).go();
    return result > 0;
  }

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

  Future<bool> createPageTodos(
    List<PagesCompanion> newPages,
    List<List<TodosCompanion>> newTodosByPage,
  ) =>
      transaction(() async {
        try {
          for (int i = 0; i < newPages.length; i++) {
            final pageId = await createPage(newPages[i]);
            for (final todo in newTodosByPage[i]) {
              final id = await db.todosDao.createTodo(todo.copyWith(pageId: Value(pageId)));
              print('todo id= $id');
            }
          }
          return true;
        } catch (e) {
          return false;
        }
      });
}
