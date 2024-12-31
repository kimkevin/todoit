import 'package:flutter/cupertino.dart';
import 'package:presentation/ui/model/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  const TodoListItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(todo.name, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24)),
      ),
    );
  }
}
