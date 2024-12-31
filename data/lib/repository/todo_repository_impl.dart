import 'package:data/datasource/todo_data_source.dart';
import 'package:data/extensions/todo_entity_model_extensions.dart';
import 'package:domain/model/todo_model.dart';
import 'package:domain/repository/todo_repository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoDataSource todoDataSource;

  TodoRepositoryImpl({required this.todoDataSource});

  @override
  Future<int> createTodo(int pageId, String name) => todoDataSource.createTodo(pageId, name);

  @override
  Future<List<TodoModel>> getTodosByPageId(int pageId) async =>
      (await todoDataSource.getTodosByPageId(pageId)).map((e) => e.toModel()).toList();

  @override
  Future<bool> updateTodo(TodoModel newTodo) => todoDataSource.updateTodo(newTodo.toEntity());
}
