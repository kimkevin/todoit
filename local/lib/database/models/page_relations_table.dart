import 'package:drift/drift.dart';

@DataClassName("PageRelation")
class PageRelations extends Table {
  IntColumn get parentPageId =>
      integer().nullable().customConstraint('REFERENCES Pages(id) ON DELETE CASCADE')();

  IntColumn get childPageId =>
      integer().customConstraint('REFERENCES Pages(id) ON DELETE CASCADE NOT NULL')();

  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {parentPageId, childPageId};
}
