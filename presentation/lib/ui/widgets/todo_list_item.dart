import 'package:flutter/material.dart';
import 'package:presentation/temp_ds.dart';
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
      textStyle = DsTextStyles.item.copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: Color(0xFF9E9FA0),
        decorationThickness: 3.0,
        color: Color(0xFF9E9FA0),
      );
      // TextStyle(
      //   decoration: TextDecoration.lineThrough, // 취소선
      //   decorationColor: Colors.red,            // 취소선 색상 (선택 사항)
      //   decorationThickness: 2.0,               // 취소선 두께 (선택 사항)
      // )
    } else {
      textStyle = DsTextStyles.item;
    }

    return GestureDetector(
      onTap: () {
        onClick(todo);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(todo.name, style: textStyle)),
          ],
        ),
      ),
    );
  }
}
