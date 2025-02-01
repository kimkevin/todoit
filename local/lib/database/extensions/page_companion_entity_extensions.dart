import 'package:data/model/entity/page_entity.dart';
import 'package:drift/drift.dart';
import 'package:local/database/database.dart';

extension PageTableExtension on Page {
  PageEntity toEntity() => PageEntity(
        id: id,
        name: name,
        orderIndex: orderIndex,
      );
}

extension PageEntityExtension on PageEntity {
  PagesCompanion toCompanion() => PagesCompanion(
        id: id > 0 ? Value(id) : const Value.absent(),
        name: Value(name),
        orderIndex: Value(orderIndex),
        updatedAt: Value(DateTime.now()),
      );
}
