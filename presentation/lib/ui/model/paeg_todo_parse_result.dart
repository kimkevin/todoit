import 'package:collection/collection.dart';

class PageTodoParseResult {
  List<ParsedPageTodo> pageTodos;

  PageTodoParseResult({required this.pageTodos});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageTodoParseResult &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(pageTodos, other.pageTodos);

  @override
  int get hashCode => const DeepCollectionEquality().hash(pageTodos);

  @override
  String toString() {
    return 'PageTodoParseResult{pageTodos: $pageTodos}';
  }
}

class ParsedPageTodo {
  final String pageName;
  final List<String> todoNames;

  ParsedPageTodo({
    required this.pageName,
    required this.todoNames,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedPageTodo &&
          runtimeType == other.runtimeType &&
          pageName == other.pageName &&
          const DeepCollectionEquality().equals(todoNames, other.todoNames);

  @override
  int get hashCode => pageName.hashCode ^ DeepCollectionEquality().hash(todoNames);

  @override
  String toString() {
    return 'ParsedPageTodo{pageName: $pageName, todoNames: $todoNames}';
  }
}
