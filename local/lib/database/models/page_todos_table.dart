import 'package:drift/drift.dart';

@DataClassName("PageTodoTable")
class PageTodos extends Table {
  IntColumn get pageId =>
      integer().customConstraint('REFERENCES Pages(id) ON DELETE RESTRICT NOT NULL')();
  IntColumn get todoId =>
      integer().customConstraint('REFERENCES Todos(id) ON DELETE RESTRICT NOT NULL')();

  @override
  Set<Column> get primaryKey => {pageId, todoId};
}
