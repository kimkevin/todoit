import 'package:data/model/entity/new_todo_entity.dart';
import 'package:domain/model/new_todo_model.dart';

extension NewTodoEntityExtension on NewTodoEntity {
  NewTodoModel toModel() => NewTodoModel(name: name);
}

extension NewTodoModelExtension on NewTodoModel {
  NewTodoEntity toEntity() => NewTodoEntity(name: name);
}
