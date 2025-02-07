class TodoUiModel {
  final int id;
  final int pageId;
  final String name;
  final int orderIndex;
  final bool completed;

  TodoUiModel({
    required this.id,
    required this.pageId,
    required this.name,
    required this.orderIndex,
    required this.completed,
  });

  TodoUiModel copyWith({
    String? name,
    bool? completed,
    bool? focused,
  }) =>
      TodoUiModel(
        id: id,
        pageId: pageId,
        name: name ?? this.name,
        orderIndex: orderIndex,
        completed: completed ?? this.completed,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoUiModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          pageId == other.pageId &&
          name == other.name &&
          orderIndex == other.orderIndex &&
          completed == other.completed;

  @override
  int get hashCode =>
      id.hashCode ^ pageId.hashCode ^ name.hashCode ^ orderIndex.hashCode ^ completed.hashCode;

  @override
  String toString() {
    return 'TodoUiModel{id: $id, pageId: $pageId, name: $name, orderIndex: $orderIndex, completed: $completed}';
  }
}
