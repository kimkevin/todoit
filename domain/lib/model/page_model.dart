class PageModel {
  final int id;
  final String name;
  final int todoCount;
  final int completionCount;
  final int completionPercent;

  PageModel({
    required this.id,
    required this.name,
    required this.todoCount,
    required this.completionCount,
    required this.completionPercent,
  });
}
