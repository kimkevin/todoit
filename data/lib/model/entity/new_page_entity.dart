import 'package:data/model/entity/new_todo_entity.dart';

class NewPageEntity {
  final String name;
  final List<NewTodoEntity> todos;

  NewPageEntity({
    required this.name,
    required this.todos,
  });
}
