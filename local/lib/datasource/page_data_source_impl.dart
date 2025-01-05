import 'package:data/datasource/page_data_source.dart';
import 'package:data/model/entity/page_entity.dart';
import 'package:local/database/database.dart';
import 'package:local/database/extensions/page_companion_entity_extensions.dart';

class PageDataSourceImpl extends PageDataSource {
  final AppDatabase database;

  PageDataSourceImpl({required this.database});

  @override
  Future<int> createPage(String title) async =>
      await database.pagesDao.createPage(PageEntity(name: title).toCompanion());

  @override
  Future<PageEntity?> getPage(int id) async => (await database.pagesDao.getPage(id))?.toEntity();

  @override
  Future<bool> updatePage(int id, String name) async {
    final newPage = PageEntity(id: id, name: name);
    final result = await database.pagesDao.updatePage(newPage.toCompanion());
    return result;
  }

  @override
  Future<bool> deletePage(int id) => database.pagesDao.deletePageAndTodos(id);

  @override
  Future<List<PageEntity>> getAllPages() async =>
      (await database.pagesDao.getAllPage()).map((e) => e.toEntity()).toList();

  @override
  Future<bool> reorderPages(int oldIndex, int newIndex) =>
      database.pagesDao.reorderTodos(oldIndex, newIndex);
}
