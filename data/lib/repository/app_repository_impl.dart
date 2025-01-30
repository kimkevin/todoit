import 'package:data/datasource/app_data_source.dart';
import 'package:domain/repository/app_repository.dart';

class AppRepositoryImpl extends AppRepository {
  final AppDataSource appDataSource;

  AppRepositoryImpl({required this.appDataSource});

  @override
  String? getLastClipboardHash() => appDataSource.getLastClipboardHash();

  @override
  Future<bool> setLastClipboardHash(String clipboardHash) =>
      appDataSource.setLastClipboardHash(clipboardHash);
}
