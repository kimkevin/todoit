import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/parser/page_todo_parser.dart';
import 'package:presentation/ui/model/paeg_todo_parse_result.dart';

void main() {
  final parser = PageTodoParser();

  test('투두만', () {
    final inputText = '''
당근
채소
과일
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: 'Untitled', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(inputText), actual);
  });

  test('페이지 + 투두(숫자.)', () {
    final inputText = '''
장보기
1. 당근
2. 채소
3. 과일
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(inputText), actual);
  });

  test('페이지 + 투두(공백1개)', () {
    final inputText = '''
장보기
 당근
 채소
 과일
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(inputText), actual);
  });

  test('페이지 + 투두(공백2개)', () {
    final inputText = '''
장보기
  당근
  채소
  과일
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(inputText), actual);
  });

  test('페이지 + 투두(-)', () {
    final inputText = '''
장보기
- 당근
- 채소
- 과일
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(inputText), actual);
  });

  test('페이지 + 투두(•)', () {
    final inputText = '''
장보기
• 당근
• 채소
• 과일
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일'])
    ]);
    expect(parser.parse(inputText), actual);
  });

  test('여러 페이지 + 투두(•)', () {
    final inputText = '''
장보기
• 당근
• 채소
• 과일
공부하기
• 수학
• 영어
• 국어
''';

    final actual = PageTodoParseResult(pageTodos: [
      ParsedPageTodo(pageName: '장보기', todoNames: ['당근', '채소', '과일']),
      ParsedPageTodo(pageName: '공부하기', todoNames: ['수학', '영어', '국어'])
    ]);
    expect(parser.parse(inputText), actual);
  });
}
