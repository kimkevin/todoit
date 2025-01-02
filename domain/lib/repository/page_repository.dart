import 'package:domain/model/page_model.dart';

abstract class PageRepository {
  Future<int> createPage(String name);

  Future<List<PageModel>> getAllPages();
}
