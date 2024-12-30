import 'package:data/datasource/page_data_source.dart';
import 'package:data/datasource/todo_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local/database/database.dart';
import 'package:local/datasource/page_data_source_impl.dart';
import 'package:local/datasource/page_todo_data_source_impl.dart';
import 'package:local/datasource/todo_data_source_impl.dart';
import 'package:local/exceptions/basic_page_deletion_exception.dart';

void main() {
  AppDatabase database = AppDatabase(true);
  TodoDataSource todoDataSource = TodoDataSourceImpl(database: database);
  PageDataSource pageDataSource = PageDataSourceImpl(database: database);
  PageTodoDataSourceImpl pageTodoDataSource = PageTodoDataSourceImpl(database: database);

  int basicPageId = 0;
  int page2Id = 0;
  int todo1Id = 0;
  int todo2Id = 0;

  group('기본 페이지 - 생성,삭제', () {
    test('생성', () async {
      basicPageId = await pageDataSource.createPage('기본');
      expect(basicPageId > 0, true, reason: '페이지가 생성되지 않았습니다');
    });

    test('삭제:불가', () async {
      try {
        await pageDataSource.deletePage(basicPageId);
      } catch (e) {
        expect(e, isA<BasicPageDeletionException>);
      }
    });
  });

  group('기본 페이지 - 생성,변경,조회,삭제', () {
    test('생성', () async {
      page2Id = await pageDataSource.createPage('뉴페이지');
      expect(page2Id > 0, true, reason: '페이지가 생성되지 않았습니다');
    });

    test('변경', () async {
      final result = await pageDataSource.updatePage(page2Id, '테스트');
      expect(result, true, reason: '이름이 변경되지 않았습니다');
    });

    test('조회', () async {
      final result = await pageDataSource.getPage(page2Id);
      expect(result?.name, '테스트', reason: '이름이 변경되지 않았습니다');
    });
  });

  group('투두1 - 생성,변경,조회', () {
    final newTodoName = '물 주문';
    todo1Id = 0;
    test('생성', () async {
      todo1Id = await todoDataSource.createTodo(page2Id, '투두1');
      expect(todo1Id > 0, true, reason: '투두가 생성되지 않았습니다');
    });

    test('변경', () async {
      final nameResult = await todoDataSource.updateTodo(todo1Id, newTodoName, false);
      expect(nameResult, true, reason: '이름이 변경되지 않았습니다');

      final completeResult = await todoDataSource.updateTodo(todo1Id, newTodoName, true);
      expect(completeResult, true, reason: '투두가 완료되지 않았습니다');
    });

    test('조회', () async {
      final result = await todoDataSource.getTodo(todo1Id);
      expect(result?.name, newTodoName, reason: '투두의 이름이 다릅니다');
      expect(result?.completed, true, reason: '투두가 완료되지 않았습니다');
    });
  });

  group('투두2 - 생성,삭제', () {
    todo2Id = 0;
    test('생성', () async {
      todo2Id = await todoDataSource.createTodo(page2Id, '투두2');
      expect(todo2Id > 0, true, reason: '투두가 생성되지 않았습니다');
    });

    test('삭제', () async {
      final result = await todoDataSource.deleteTodo(todo2Id);
      expect(result, 1, reason: '투두가 삭제되지 않았습니다');
    });
  });

  group('페이지(삭제)', () {
    test('삭제', () async {
      final result = await pageDataSource.deletePage(page2Id);
      expect(result, true, reason: '페이지가 삭제되지 않았습니다');
    });

    test('투두 조회', () async {
      final result = await todoDataSource.getTodo(todo1Id);
      expect(result, null, reason: '투두가 삭제되지 않았습니다');
    });
  });

  group('페이지/투두 - 빈상태', () {
    test('페이지 빈상태', () async {
      final result = await pageDataSource.getPage(page2Id);
      expect(result, null, reason: '페이지가 비어있지 않습니다');
    });
    test('투두 빈상태', () async {
      final result1 = await todoDataSource.getTodo(todo1Id);
      final result2 = await todoDataSource.getTodo(todo2Id);
      expect(result1, null, reason: '투두1 삭제되지 않았습니다');
      expect(result2, null, reason: '투두2 삭제되지 않았습니다');
    });
    test('페이지투두  빈상태', () async {
      final result1 = await pageTodoDataSource.getAllPageTodo();
      expect(result1.isEmpty, true, reason: '페이지투두가 비어있지 않습니다');
    });
  });
}
