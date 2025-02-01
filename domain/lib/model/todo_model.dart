class TodoModel {
  final int id;
  final int pageId;
  final String name;
  final int orderIndex;
  final bool completed;

  TodoModel({
    required this.id,
    required this.pageId,
    required this.name,
    required this.orderIndex,
    required this.completed,
  });
}
