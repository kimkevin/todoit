import 'package:drift/drift.dart';

@DataClassName("PageTodoTable")
class PageTodos extends Table {
  // CASCADE Todos의 행이 삭제될 때 관련 PageTodos 행도 자동으로 삭제
  IntColumn get pageId =>
      integer().customConstraint('REFERENCES Pages(id) ON DELETE CASCADE NOT NULL')();

  IntColumn get todoId =>
      integer().customConstraint('REFERENCES Todos(id) ON DELETE CASCADE NOT NULL')();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {pageId, todoId};
}
