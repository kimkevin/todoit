import 'package:data/datasource/page_data_source.dart';
import 'package:data/extensions/new_page_entity_model_extensions.dart';
import 'package:data/extensions/page_entity_model_extensions.dart';
import 'package:domain/model/new_page_model.dart';
import 'package:domain/model/page_model.dart';
import 'package:domain/repository/page_repository.dart';

class PageRepositoryImpl extends PageRepository {
  final PageDataSource pageDataSource;

  PageRepositoryImpl({required this.pageDataSource});

  @override
  Future<int> createPage(String name) => pageDataSource.createPage(name);

  @override
  Future<List<PageModel>> getAllPages() async =>
      (await pageDataSource.getAllPages()).map((e) => e.toModel()).toList();

  @override
  Future<bool> deletePage(int id) => pageDataSource.deletePage(id);

  @override
  Future<bool> reorderTodos(int oldIndex, int newIndex) =>
      pageDataSource.reorderPages(oldIndex, newIndex);

  @override
  Future<bool> createPageTodos(List<NewPageModel> newPages) =>
      pageDataSource.createPageTodos(newPages.map((model) => model.toEntity()).toList());

  @override
  Future<bool> updatePage(int id, {String? name}) => pageDataSource.updatePage(id, name: name);
}
