import 'package:domain/model/new_page_model.dart';
import 'package:domain/model/page_model.dart';

abstract class PageRepository {
  Future<int> createPage(String name);

  Future<bool> createPageTodos(List<NewPageModel> newPages);

  Future<List<PageModel>> getAllPages();

  Future<bool> reorderTodos(int oldIndex, int newIndex);
}
