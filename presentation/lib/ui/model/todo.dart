class Todo {
  final int id;
  final String name;
  final bool completed;

  Todo({required this.id, required this.name, required this.completed});

  Todo copyWith({String? name, bool? completed}) => Todo(
        id: id,
        name: name ?? this.name,
        completed: completed ?? this.completed,
      );

  @override
  String toString() => 'Todo{id: $id, name: $name, completed: $completed}';
}
