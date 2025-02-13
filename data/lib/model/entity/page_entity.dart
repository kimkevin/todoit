class PageEntity {
  final int id;
  final String name;
  final int todoCount;
  final int completionCount;
  final int completionPercent;
  final int orderIndex;

  PageEntity({
    this.id = 0,
    required this.name,
    this.todoCount = 0,
    this.completionCount = 0,
    this.completionPercent = 0,
    this.orderIndex = 0,
  });
}
