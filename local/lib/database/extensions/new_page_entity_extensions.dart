import 'package:data/model/entity/new_page_entity.dart';
import 'package:drift/drift.dart';
import 'package:local/database/database.dart';

extension PageEntityExtension on NewPageEntity {
  PagesCompanion toCompanion() => PagesCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      );
}
