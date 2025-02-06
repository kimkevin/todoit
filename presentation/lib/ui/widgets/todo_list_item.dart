import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_ds/ui/widgets/ds_row.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/ui/widgets/dash_divider.dart';

class TodoListItem extends StatefulWidget {
  final int? reorderIndex;
  final TextEditingController controller;
  // final String text;
  final VoidCallback actionClick;
  final VoidCallback deleteClick;
  final VoidCallback onTap;
  final Function(String) onTextChanged;

  // final VoidCallback? onNewTodoFocused;
  final bool isCompleted;
  final bool isEditMode;
  final bool isNew;

  const TodoListItem({
    super.key,
    required this.controller,
    this.reorderIndex,
    required this.onTap,
    required this.onTextChanged,
    this.isCompleted = false,
    this.isEditMode = false,
    required this.deleteClick,
    required this.actionClick,
    // this.onNewTodoFocused,
    this.isNew = false,
  });

  @override
  State<StatefulWidget> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  final FocusNode _focusNode = FocusNode();
  bool isNew = false;

  @override
  void initState() {
    super.initState();

    isNew = widget.isNew;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isNew) {
        _focusNode.requestFocus();
        // widget.onNewTodoFocused?.call();
        isNew = false;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void onTextChanged(String text) {
    widget.onTextChanged(text);
  }

  Widget _buildTextField(bool isEditMode) {
    TextStyle textStyle;
    if (widget.isCompleted && widget.controller.text.isNotEmpty == true) {
      textStyle = DsTextStyles.b1.copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: DsColorPalette.gray400,
        decorationThickness: 2.0,
        color: DsColorPalette.gray400,
      );
      // TextStyle(
      //   decoration: TextDecoration.lineThrough, // 취소선
      //   decorationColor: Colors.red,            // 취소선 색상 (선택 사항)
      //   decorationThickness: 2.0,               // 취소선 두께 (선택 사항)
      // )
    } else {
      textStyle = DsTextStyles.b1.copyWith(color: DsColorPalette.gray800);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        controller: widget.controller,
        style: textStyle,
        focusNode: _focusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onTap: widget.onTap,
        // textInputAction: TextInputAction.done,
        onChanged: onTextChanged,
        decoration: InputDecoration(
          hintText: '할일 입력',
          hintStyle: DsTextStyles.b1.copyWith(color: DsColorPalette.gray300),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DsRow(
      minHeight: 60,
      leading: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: widget.isEditMode
            ? SizedBox(width: 32)
            : GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.actionClick();
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 32,
                    top: 16,
                    bottom: 16,
                    right: 16,
                  ),
                  child: widget.isCompleted
                      ? DsImage(
                          Assets.svg.icCheck.path,
                          width: 24,
                          height: 24,
                          color: Color(0xFFFF8794),
                        )
                      : DsImage(
                          Assets.svg.icCircle.path,
                          width: 24,
                          height: 24,
                        ),
                ),
              ),
      ),
      content: _buildTextField(widget.isEditMode),
      trailing: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: !widget.isEditMode
            ? SizedBox(width: 32)
            : Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.deleteClick,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: DsImage(
                        Assets.svg.icTrash.path,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  if (widget.reorderIndex != null)
                    ReorderableDragStartListener(
                      index: widget.reorderIndex!,
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 32, top: 10, bottom: 10),
                          child: DsImage(
                            Assets.svg.icDragHandle.path,
                            width: 24,
                            height: 24,
                          )),
                    )
                ],
              ),
      ),
      bottomDivider: DashDivider(horizontalPadding: 32),
    );
  }
}
