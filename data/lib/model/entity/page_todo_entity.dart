import 'package:data/model/entity/todo_entity.dart';

class PageTodoEntity {
  final int pageId;
  final TodoEntity todo;
  final int orderIndex;

  PageTodoEntity({
    required this.pageId,
    required this.todo,
    required this.orderIndex,
  });
}
