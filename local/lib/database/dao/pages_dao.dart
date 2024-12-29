import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/pages_table.dart';

part 'pages_dao.g.dart';

@DriftAccessor(tables: [Pages])
class PagesDao extends DatabaseAccessor<AppDatabase> with _$PagesDaoMixin {
  PagesDao(super.db);

  Future<int> createPage(PagesCompanion page) => into(pages).insert(page);

  Future<PageTable> getPage(int id) => (select(pages)..where((p) => p.id.equals(id))).getSingle();

  Future<bool> updatePage(PagesCompanion page) => update(pages).replace(page);

  Future<int> deleteTodo(int id) => (delete(pages)..where((p) => p.id.equals(id))).go();
}
