class PageUiModel {
  final int id;
  final String name;

  PageUiModel({
    required this.id,
    required this.name,
  });

  PageUiModel copyWith({String? name}) => PageUiModel(
        id: id,
        name: name ?? this.name,
      );

  @override
  String toString() => 'Page{id: $id, name: $name}';
}
