import 'package:data/model/entity/new_todo_entity.dart';
import 'package:drift/drift.dart';
import 'package:local/database/database.dart';

extension TodoEntityExtension on NewTodoEntity {
  TodosCompanion toCompanion() => TodosCompanion(
        name: Value(name),
        completed: Value(false),
        updatedAt: Value(DateTime.now()),
      );
}
