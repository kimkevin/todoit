import 'package:data/datasource/page_data_source.dart';
import 'package:data/datasource/todo_data_source.dart';
import 'package:data/repository/page_repository_impl.dart';
import 'package:data/repository/todo_repository_impl.dart';
import 'package:domain/repository/page_repository.dart';
import 'package:domain/repository/todo_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:local/database/database.dart';
import 'package:local/datasource/page_data_source_impl.dart';
import 'package:local/datasource/todo_data_source_impl.dart';

GetIt getIt = GetIt.instance;

// @InjectableInit(preferRelativeImports: false)
// void configureDependencies() => getIt.init();

void setupGetIt() {
  // app
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase(false));

  // preferences
  // getIt.registerLazySingleton<UserPreferences>(() => UserPreferences());

  // datasource
  getIt.registerLazySingleton<TodoDataSource>(
    () => TodoDataSourceImpl(database: getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<PageDataSource>(
    () => PageDataSourceImpl(database: getIt<AppDatabase>()),
  );

  // repository
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(todoDataSource: getIt<TodoDataSource>()),
  );
  getIt.registerLazySingleton<PageRepository>(
    () => PageRepositoryImpl(pageDataSource: getIt<PageDataSource>()),
  );
}
