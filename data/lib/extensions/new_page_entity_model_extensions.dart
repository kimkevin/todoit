import 'package:data/extensions/new_todo_entity_model_extensions.dart';
import 'package:data/model/entity/new_page_entity.dart';
import 'package:domain/model/new_page_model.dart';

extension NewPageEntityExtension on NewPageEntity {
  NewPageModel toModel() => NewPageModel(
        name: name,
        todos: todos.map((e) => e.toModel()).toList(),
      );
}

extension PageModelExtension on NewPageModel {
  NewPageEntity toEntity() => NewPageEntity(
        name: name,
        todos: todos.map((e) => e.toEntity()).toList(),
      );
}
