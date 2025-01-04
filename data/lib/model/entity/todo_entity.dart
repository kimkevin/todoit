class TodoEntity {
  final int id;
  final String name;
  final int orderIndex;
  final bool completed;

  TodoEntity({this.id = 0, required this.name, this.orderIndex = 0, this.completed = false});
}
