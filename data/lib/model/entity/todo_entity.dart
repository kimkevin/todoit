class TodoEntity {
  final int id;
  final int pageId;
  final String name;
  final int orderIndex;
  final bool completed;

  TodoEntity({
    this.id = 0,
    required this.pageId,
    required this.name,
    this.orderIndex = 0,
    this.completed = false,
  });

  @override
  String toString() {
    return 'TodoEntity{id: $id, name: $name, completed: $completed}';
  }
}
