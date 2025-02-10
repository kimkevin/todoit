class NewPageItemUiModel {
  final String name;
  final List<String> todoNames;

  NewPageItemUiModel({
    this.name = '',
    this.todoNames = const [],
  });

  NewPageItemUiModel copyWith({String? name, List<String>? todoNames}) => NewPageItemUiModel(
        name: name ?? this.name,
        todoNames: todoNames ?? this.todoNames,
      );

  @override
  String toString() {
    return 'NewPageItemUiModel{name: $name, todoNames: $todoNames}';
  }
}
