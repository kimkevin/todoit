class TodoUiModel {
  final int id;
  final String name;
  final bool completed;

  TodoUiModel({required this.id, required this.name, required this.completed});

  TodoUiModel copyWith({String? name, bool? completed}) => TodoUiModel(
        id: id,
        name: name ?? this.name,
        completed: completed ?? this.completed,
      );

  @override
  String toString() => 'Todo{id: $id, name: $name, completed: $completed}';
}
