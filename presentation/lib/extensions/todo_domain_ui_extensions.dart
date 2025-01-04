import 'package:domain/model/todo_model.dart';
import 'package:presentation/ui/model/todo.dart';

extension TodoDomainExtension on TodoModel {
  TodoUiModel toUiModel() => TodoUiModel(
        id: id,
        name: name,
        orderIndex: orderIndex,
        completed: completed,
      );
}

extension TodoUiExtension on TodoUiModel {
  TodoModel toModel() => TodoModel(
        id: id,
        name: name,
        orderIndex: orderIndex,
        completed: completed,
      );
}
