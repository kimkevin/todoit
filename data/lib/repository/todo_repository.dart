import 'package:data/datasource/todo_data_source.dart';
import 'package:data/extensions/todo_entity_to_model_extensions.dart';
import 'package:domain/model/todo_model.dart';
import 'package:domain/repository/todo_repository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoDataSource todoDataSource;

  TodoRepositoryImpl({required this.todoDataSource});

  @override
  Future<TodoModel?> getTodo(int id) async => (await todoDataSource.getTodo(id))?.toModel();
}
