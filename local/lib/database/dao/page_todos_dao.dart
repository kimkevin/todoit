import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/page_todos_table.dart';

part 'page_todos_dao.g.dart';

@DriftAccessor(tables: [PageTodos])
class PageTodosDao extends DatabaseAccessor<AppDatabase> with _$PageTodosDaoMixin {
  PageTodosDao(super.db);
}
