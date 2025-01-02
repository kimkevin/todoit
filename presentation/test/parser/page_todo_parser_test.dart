import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/parser/page_todo_parser.dart';
import 'package:presentation/ui/model/paeg_todo_parse_result.dart';

void main() {
  test('투두만', () {
    final inputText = '''
당근
채소
과일
''';

    final parser = PageTodoParser(inputText);
    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: 'Untitled', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(), actual);
  });

  test('페이지 + 투두(숫자.)', () {
    final inputText = '''
장보기
1. 당근
2. 채소
3. 과일
''';

    final parser = PageTodoParser(inputText);
    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(), actual);
  });

  test('페이지 + 투두(공백1개)', () {
    final inputText = '''
장보기
 당근
 채소
 과일
''';

    final parser = PageTodoParser(inputText);
    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(), actual);
  });

  test('페이지 + 투두(공백2개)', () {
    final inputText = '''
장보기
  당근
  채소
  과일
''';

    final parser = PageTodoParser(inputText);
    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(), actual);
  });

  test('페이지 + 투두(-)', () {
    final inputText = '''
장보기
- 당근
- 채소
- 과일
''';

    final parser = PageTodoParser(inputText);
    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(), actual);
  });

  test('페이지 + 투두(•)', () {
    final inputText = '''
장보기
• 당근
• 채소
• 과일
''';

    final parser = PageTodoParser(inputText);
    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(), actual);
  });
}
