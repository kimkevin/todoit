import 'package:data/model/entity/todo_entity.dart';
import 'package:drift/drift.dart';
import 'package:local/database/database.dart';

extension TodoEntityExtension on TodoEntity {
  TodosCompanion toCompanion() => TodosCompanion(
    id: id > 0 ? Value(id) : const Value.absent(),
    name: Value(name),
    completed: Value(completed),
    updatedAt: Value(DateTime.now()),
  );
}

extension TodoTableExtension on TodoTable {
  TodoEntity toEntity() => TodoEntity(id: id, name: name, completed: completed);
}
