import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/model/todo.dart';

enum TextMode {
  text,
  edit // check 안됨
}

class TodoListItem extends StatefulWidget {
  final int? reorderIndex;
  final TodoUiModel? todo;
  final Function(TodoUiModel)? actionClick;
  final Function(int)? deleteClick;
  final bool isEditMode;

  const TodoListItem({
    super.key,
    this.reorderIndex,
    this.todo,
    this.isEditMode = true,
    this.deleteClick,
    this.actionClick,
  });

  @override
  State<StatefulWidget> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.todo?.name);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    if (widget.todo?.completed == true) {
      textStyle = DsTextStyles.todo.copyWith(
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
      textStyle = DsTextStyles.todo;
    }

    return GestureDetector(
      onTap: () {
        if (widget.actionClick == null) return;
        HapticFeedback.lightImpact();
        if (widget.todo != null) {
          widget.actionClick!(widget.todo!);
        }
      },
      child: Container(
        color: Colors.transparent,
        constraints: BoxConstraints(minHeight: 74),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: widget.isEditMode && widget.reorderIndex != null
                  ? ReorderableDragStartListener(
                      index: widget.reorderIndex!,
                      child: _buildTextField(widget.isEditMode),
                    )
                  : _buildTextField(widget.isEditMode),
            ),
            AnimatedOpacity(
              opacity: widget.isEditMode ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: Row(
                children: [
                  Visibility(
                      visible: widget.todo != null && widget.deleteClick != null,
                      child: InkWell(
                        onTap: () {
                          widget.deleteClick!(widget.todo!.id);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 29),
                          child: Text('삭제'),
                        ),
                      )),
                  if (widget.reorderIndex != null)
                    ReorderableDragStartListener(
                      index: widget.reorderIndex!,
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

  TextField _buildTextField(bool isEditMode) => TextField(
        controller: textController,
        style: DsTextStyles.todo.copyWith(color: Color(0xFF242B34)),
        enabled: isEditMode,
        decoration: InputDecoration(
          hintText: '할일 입력',
          hintStyle: DsTextStyles.todo.copyWith(color: Color(0xFFC8C8C8)),
          border: InputBorder.none,
        ),
      );
}
