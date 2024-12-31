class Todo {
  final int id;
  final String name;
  final bool completed;

  Todo({required this.id, required this.name, required this.completed});

  @override
  String toString() =>
    'Todo{id: $id, name: $name, completed: $completed}';
}
