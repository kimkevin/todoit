import 'package:local/database/database.dart';

class PageTodoDataSourceImpl {
  final AppDatabase database;

  PageTodoDataSourceImpl({required this.database});

  Future<List<PageTodoTable>> getAllPageTodo() => database.pageTodosDao.getAllPageTodo();
}
