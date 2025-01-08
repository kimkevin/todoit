import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/model/todo.dart';

class TodoListItem extends StatelessWidget {
  final int index;
  final TodoUiModel todo;
  final Function(TodoUiModel) actionClick;
  final Function(int) deleteClick;
  final bool isEditMode;

  const TodoListItem({
    super.key,
    required this.index,
    required this.todo,
    required this.isEditMode,
    required this.deleteClick,
    required this.actionClick,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    if (todo.completed) {
      textStyle = DsTextStyles.item.copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: Color(0xFF9E9FA0),
        decorationThickness: 2.0,
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
        HapticFeedback.lightImpact();
        actionClick(todo);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            if (!isEditMode) Expanded(child: Text(todo.name, style: textStyle)),
            if (isEditMode)
              Expanded(
                child: ReorderableDragStartListener(
                  index: index,
                  child: Text(
                    todo.name,
                    style: DsTextStyles.item,
                  ),
                ),
              ),
            AnimatedOpacity(
              opacity: isEditMode ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      deleteClick(todo.id);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 29),
                      child: Text('삭제'),
                    ),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: SvgPicture.asset(
                      Assets.svg.svgHandle.path,
                      width: 18,
                      height: 6,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
