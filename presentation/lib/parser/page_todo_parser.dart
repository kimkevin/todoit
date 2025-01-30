import 'package:presentation/ui/model/paeg_todo_parse_result.dart';

class PageTodoParser {
  PageTodoParseResult? parse(String inputText) {
    final lines = inputText.split('\n').toList();
    List<ParsedPageTodo> result = [];
    String? currentPageTitle;
    List<String> currentTodos = [];

    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      if (_isPageTitle(line)) {
        // 기존 페이지 저장
        if (currentPageTitle != null) {
          result.add(ParsedPageTodo(pageName: currentPageTitle, todoNames: currentTodos));
        }
        // 새 페이지 시작
        currentPageTitle = line;
        currentTodos = [];
      } else if (_isTodo(line)) {
        // 투두 추가
        currentTodos.add(line.replaceFirst(RegExp(r'^(\s+|\d+\.|\•|-)\s*'), '').trim());
      }
    }

    // 마지막 페이지 저장
    if (currentPageTitle != null) {
      result.add(ParsedPageTodo(pageName: currentPageTitle, todoNames: currentTodos));
    }

    // 페이지만 있는 경우 'Untitled' 페이지로 처리
    if (_isAllPages(result)) {
      final todoNames = result.map((e) => e.pageName).toList();
      if (todoNames.length <= 1) {
        return null;
      }
      result.clear();
      result.add(ParsedPageTodo(
        pageName: 'Untitled',
        todoNames: todoNames,
      ));
    }

    return PageTodoParseResult(pageTodos: result);
  }

  bool _isAllPages(List<ParsedPageTodo> result) {
    return !result.any((e) => e.todoNames.isNotEmpty);
  }

  bool _isPageTitle(String line) {
    // 페이지 제목은 숫자, 기호, 공백으로 시작하지 않는 줄
    return line.isNotEmpty && !RegExp(r'^(\d+\.|\•|-|\s)').hasMatch(line);
  }

  bool _isTodo(String line) {
    // 투두는 공백으로 시작하거나 숫자/기호로 시작
    return RegExp(r'^\s+|\d+\.|\•|-').hasMatch(line);
  }
}
