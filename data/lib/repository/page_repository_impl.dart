import 'package:data/datasource/page_data_source.dart';
import 'package:data/extensions/page_entity_model_extensions.dart';
import 'package:domain/model/page_model.dart';
import 'package:domain/repository/page_repository.dart';

class PageRepositoryImpl extends PageRepository {
  final PageDataSource pageDataSource;

  PageRepositoryImpl({required this.pageDataSource});

  // Future<bool> initBasicPage() async {
  //   final basicPage = await pageDataSource.getPage(1);
  //   if (basicPage == null) {
  //     final id = await pageDataSource.createPage("basic");
  //     return id > 0;
  //   }
  //   return true;
  // }

  @override
  Future<int> createPage(String name) => pageDataSource.createPage(name);

  @override
  Future<List<PageModel>> getAllPages() async =>
      (await pageDataSource.getAllPages()).map((e) => e.toModel()).toList();
}
