import 'package:data/datasource/page_data_source.dart';
import 'package:domain/repository/page_repository.dart';

class PageRepositoryImpl extends PageRepository {
  final PageDataSource pageDataSource;

  PageRepositoryImpl({required this.pageDataSource});

  @override
  Future<bool> initBasicPage() async {
    final basicPage = await pageDataSource.getPage(1);
    if (basicPage == null) {
      final id = await pageDataSource.createPage("basic");
      return id > 0;
    }
    return true;
  }
}
