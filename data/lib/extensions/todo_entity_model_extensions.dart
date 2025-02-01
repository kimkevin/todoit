import 'package:data/model/entity/todo_entity.dart';
import 'package:domain/model/todo_model.dart';

extension TodoEntityExtension on TodoEntity {
  TodoModel toModel() => TodoModel(
        id: id,
        pageId: pageId,
        name: name,
        orderIndex: orderIndex,
        completed: completed,
      );
}

extension TodoModelExtension on TodoModel {
  TodoEntity toEntity() => TodoEntity(
        id: id,
        pageId: pageId,
        name: name,
        orderIndex: orderIndex,
        completed: completed,
      );
}
