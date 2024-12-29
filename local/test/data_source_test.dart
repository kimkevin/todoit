import 'package:data/datasource/todo_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local/database/database.dart';
import 'package:local/datasource/todo_data_source_impl.dart';

void main() {
  AppDatabase database = AppDatabase(true);
  TodoDataSource todoDataSource = TodoDataSourceImpl(database: database);

  group('투두', () {
    final todoName = '물 주문하기';
    final newTodoName = '물 주문';
    int id = 0;
    test('생성', () async {
      id = await todoDataSource.createTodo(todoName);
      expect(id > 0, true);
    });

    test('변경', () async {
      final nameResult = await todoDataSource.updateTodo(id, newTodoName, false);
      expect(nameResult, true, reason: '이름이 변경되지 않았습니다');

      final completeResult = await todoDataSource.updateTodo(id, newTodoName, true);
      expect(completeResult, true, reason: '투두가 완료되지 않았습니다');
    });

    test('조회', () async {
      final result = await todoDataSource.getTodo(id);
      expect(result.name, newTodoName, reason: '투두의 이름이 다릅니다');
      expect(result.completed, true, reason: '투두가 완료되지 않았습니다');
    });

    test('삭제', () async {
      final result = await todoDataSource.deleteTodo(id);
      expect(result, true);
    });
  });
}
