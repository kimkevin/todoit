import 'package:data/datasource/page_data_source.dart';
import 'package:data/model/entity/new_page_entity.dart';
import 'package:data/model/entity/page_entity.dart';
import 'package:local/database/database.dart';
import 'package:local/database/extensions/new_page_entity_extensions.dart';
import 'package:local/database/extensions/new_todo_entity_extensions.dart';
import 'package:local/database/extensions/page_companion_entity_extensions.dart';

class PageDataSourceImpl extends PageDataSource {
  final AppDatabase database;

  PageDataSourceImpl({required this.database});

  @override
  Future<int> createPage(String title) async =>
      await database.pagesDao.createPage(PageEntity(name: title).toCompanion());

  @override
  Future<PageEntity?> getPage(int id) async {
    final page = await database.pagesDao.getPage(id);
    if (page == null) return null;
    final todoCount = (await database.todosDao.getTodosByPageId(id)).length;
    return PageEntity(
        id: page.id, name: page.name, orderIndex: page.orderIndex, todoCount: todoCount);
  }

  @override
  Future<bool> updatePage(int id, {String? name}) =>
      database.pagesDao.updatePageWith(id, name: name);

  @override
  Future<bool> deletePage(int id) => database.pagesDao.deletePage(id);

  @override
  Future<List<PageEntity>> getAllPages() async {
    final pages = await database.pagesDao.getAllPage();

    return await Future.wait(pages.map((page) async {
      final todos = await database.todosDao.getTodosByPageId(page.id);
      final completionCount = todos.where((todo) => todo.completed).length;
      final totalCount = todos.length;
      final completionPercent = ((completionCount / totalCount) * 100).toInt();

      return PageEntity(
        id: page.id,
        name: page.name,
        todoCount: totalCount,
        completionCount: completionCount,
        completionPercent: completionPercent,
        orderIndex: page.orderIndex,
      );
    }));
  }

  @override
  Future<bool> reorderPages(int oldIndex, int newIndex) =>
      database.pagesDao.reorderTodos(oldIndex, newIndex);

  @override
  Future<bool> createPageTodos(List<NewPageEntity> newPages) => database.pagesDao.createPageTodos(
        newPages.map((p) => p.toCompanion()).toList(),
        newPages.map((p) => p.todos.map((t) => t.toCompanion()).toList()).toList(),
      );
}
