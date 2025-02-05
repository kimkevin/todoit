class NewTodoItemUiModel {
  final String name;
  final bool deletable;

  NewTodoItemUiModel({
    this.name = '',
    this.deletable = true,
  });

  NewTodoItemUiModel copyWith({
    String? name,
  }) =>
      NewTodoItemUiModel(
        name: name ?? this.name,
      );

  @override
  String toString() {
    return 'NewTodoItemModel{name: $name}';
  }
}
