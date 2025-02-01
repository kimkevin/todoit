import 'package:domain/model/todo_model.dart';
import 'package:presentation/ui/model/todo.dart';

extension TodoDomainExtension on TodoModel {
  TodoUiModel toUiModel() => TodoUiModel(
        id: id,
        pageId: pageId,
        name: name,
        orderIndex: orderIndex,
        completed: completed,
      );
}
