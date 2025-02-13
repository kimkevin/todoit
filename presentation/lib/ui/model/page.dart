class PageUiModel {
  final int id;
  final String name;
  final int todoCount;
  final int completionCount;
  final int completionPercent;

  PageUiModel({
    required this.id,
    required this.name,
    required this.todoCount,
    required this.completionCount,
    required this.completionPercent,
  });

  bool get completed => completionPercent == 100;

  PageUiModel copyWith({String? name}) => PageUiModel(
        id: id,
        name: name ?? this.name,
        todoCount: todoCount,
        completionCount: completionCount,
        completionPercent: completionPercent,
      );

  @override
  String toString() => 'Page{id: $id, name: $name, totalTodoCount: $todoCount}';
}
