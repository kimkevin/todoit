import 'package:flutter/material.dart';
import 'package:presentation/ui/model/todo.dart';

class TodoListItem extends StatelessWidget {
  final TodoUiModel todo;
  final Function(TodoUiModel) onClick;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    if (todo.completed) {
      textStyle = TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 24,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.black,
      );
    } else {
      textStyle = TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 24,
      );
    }

    return GestureDetector(
      onTap: () {
        onClick(todo);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(todo.name, style: textStyle)),
          ],
        ),
      ),
    );
  }
}
