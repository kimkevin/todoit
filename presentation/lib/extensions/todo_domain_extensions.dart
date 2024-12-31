import 'package:domain/model/todo_model.dart';
import 'package:presentation/ui/model/todo.dart';

extension TodoDomainExtension on TodoModel {
  Todo toUiModel() => Todo(
        id: id,
        name: name,
        completed: completed,
      );
}
