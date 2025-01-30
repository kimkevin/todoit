import 'package:domain/model/new_todo_model.dart';

class NewPageModel {
  final String name;
  final List<NewTodoModel> todos;

  NewPageModel({
    required this.name,
    required this.todos,
  });
}
