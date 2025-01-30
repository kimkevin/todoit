import 'dart:collection';

import 'package:presentation/ui/model/new_todo_item_model.dart';

class NewPageItemUiModel {
  final String name;
  final List<NewTodoItemUiModel> _todoItemModels;
  final bool autoFocus;

  NewPageItemUiModel({
    this.name = '',
    List<NewTodoItemUiModel> todoItemModels = const [],
    this.autoFocus = false,
  }) : _todoItemModels = List.unmodifiable(todoItemModels);

  UnmodifiableListView<NewTodoItemUiModel> get todoItemModels =>
      UnmodifiableListView(_todoItemModels);

  NewPageItemUiModel copyWith({
    String? name,
    bool? autoFocus,
    List<NewTodoItemUiModel>? todoItemModels,
  }) =>
      NewPageItemUiModel(
        name: name ?? this.name,
        autoFocus: autoFocus ?? this.autoFocus,
        todoItemModels: todoItemModels ?? this.todoItemModels,
      );

  @override
  String toString() {
    return 'NewPageItemModel{name: $name, todoItemModels: $todoItemModels, autoFocus: $autoFocus}';
  }
}
