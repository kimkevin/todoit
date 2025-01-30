class NewTodoItemUiModel {
  final String name;
  final bool autoFocus;

  NewTodoItemUiModel({
    this.name = '',
    this.autoFocus = false,
  });

  NewTodoItemUiModel copyWith({
    String? name,
    bool? autoFocus,
  }) =>
      NewTodoItemUiModel(
        name: name ?? this.name,
        autoFocus: autoFocus ?? this.autoFocus,
      );

  @override
  String toString() {
    return 'NewTodoItemModel{name: $name, autoFocus: $autoFocus}';
  }
}
