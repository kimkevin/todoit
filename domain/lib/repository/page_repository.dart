import 'package:domain/model/page_model.dart';

abstract class PageRepository {
  Future<int> createPage(String name);

  Future<bool> createPageTodos(String name, List<String> todoNames);

  Future<List<PageModel>> getAllPages();

  Future<bool> reorderTodos(int oldIndex, int newIndex);
}
