import 'package:drift/drift.dart';
import 'package:local/database/database.dart';
import 'package:local/database/models/page_relations_table.dart';

part 'page_relations_dao.g.dart';

@DriftAccessor(tables: [PageRelations])
class PageRelationsDao extends DatabaseAccessor<AppDatabase> with _$PageRelationsDaoMixin {
  PageRelationsDao(super.db);
}
