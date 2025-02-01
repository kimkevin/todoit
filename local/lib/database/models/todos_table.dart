import 'package:drift/drift.dart';

@DataClassName("Todo")
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pageId =>
      integer().customConstraint('REFERENCES Pages(id) ON DELETE CASCADE NOT NULL')();
  TextColumn get name => text().withLength(max: 30)();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
