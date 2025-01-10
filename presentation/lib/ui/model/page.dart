class PageUiModel {
  final int id;
  final String name;
  final int todoCount;

  PageUiModel({
    required this.id,
    required this.name,
    required this.todoCount,
  });

  PageUiModel copyWith({String? name}) => PageUiModel(
        id: id,
        name: name ?? this.name,
        todoCount: todoCount,
      );

  @override
  String toString() => 'Page{id: $id, name: $name, totalTodoCount: $todoCount}';
}
