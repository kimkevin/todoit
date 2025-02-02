import 'package:data/model/entity/new_page_entity.dart';
import 'package:data/model/entity/page_entity.dart';

abstract class PageDataSource {
  Future<int> createPage(String name);

  Future<bool> createPageTodos(List<NewPageEntity> newPages);

  Future<PageEntity?> getPage(int id);

  Future<bool> updatePage(int id, {String? name});

  Future<bool> deletePage(int id);

  Future<List<PageEntity>> getAllPages();

  Future<bool> reorderPages(int oldIndex, int newIndex);
}
