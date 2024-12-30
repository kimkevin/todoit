import 'package:data/model/entity/todo_entity.dart';
import 'package:domain/model/todo_model.dart';

extension TodoEntityExtension on TodoEntity {
  TodoModel toModel() => TodoModel(id: id, name: name, completed: completed);
}
