import 'package:data/model/entity/page_entity.dart';

abstract class PageDataSource {
  Future<int> createPage(String title);

  Future<PageEntity?> getPage(int id);

  Future<bool> updatePage(int id, String title);

  Future<bool> deletePage(int id);

  Future<bool> isPageExisted();

  Future<bool> initBasicPage();
}
