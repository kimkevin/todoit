import 'package:data/model/entity/page_entity.dart';

abstract class PageDataSource {
  Future<int> createPage(String name);

  Future<bool> createPageTodos(String name, List<String> todoNames);

  Future<PageEntity?> getPage(int id);

  Future<bool> updatePage(int id, String title);

  Future<bool> deletePage(int id);

  Future<List<PageEntity>> getAllPages();

  Future<bool> reorderPages(int oldIndex, int newIndex);
}
