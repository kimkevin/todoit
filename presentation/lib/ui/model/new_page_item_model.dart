import 'dart:collection';

class NewPageItemModel {
  final String name;
  final List<NewTodoItemModel> _todoItemModels;
  final bool autoFocus;

  NewPageItemModel({
    this.name = '',
    List<NewTodoItemModel> todoItemModels = const [],
    this.autoFocus = false,
  }) : _todoItemModels = List.unmodifiable(todoItemModels);

  UnmodifiableListView<NewTodoItemModel> get todoItemModels =>
      UnmodifiableListView(_todoItemModels);

  NewPageItemModel copyWith({
    String? name,
    bool? autoFocus,
    List<NewTodoItemModel>? todoItemModels,
  }) =>
      NewPageItemModel(
        name: name ?? this.name,
        autoFocus: autoFocus ?? this.autoFocus,
        todoItemModels: todoItemModels ?? this.todoItemModels,
      );

  @override
  String toString() {
    return 'NewPageItemModel{name: $name, todoItemModels: $todoItemModels, autoFocus: $autoFocus}';
  }
}

class NewTodoItemModel {
  final String name;
  final bool autoFocus;

  NewTodoItemModel({
    this.name = '',
    this.autoFocus = false,
  });

  @override
  String toString() {
    return 'NewTodoItemModel{name: $name, autoFocus: $autoFocus}';
  }
}
