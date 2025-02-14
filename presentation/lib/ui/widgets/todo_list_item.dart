import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_ds/ui/widgets/ds_row.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/ui/widgets/dash_divider.dart';

class TodoTextInputState {
  final TextEditingController controller;
  final FocusNode focusNode;

  TodoTextInputState({
    String? name,
  })  : controller = TextEditingController(text: name ?? ''),
        focusNode = FocusNode();

  void addListener(Function(bool) onFocusChange) {
    focusNode.addListener(() {
      onFocusChange(focusNode.hasFocus);
    });
  }

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class TodoListItem extends StatefulWidget {
  final int? reorderIndex;
  final TodoTextInputState inputState;
  final Function(bool) actionClick;
  final VoidCallback deleteClick;
  final VoidCallback onClick;
  final Function(String) onTextChanged;
  final bool isCompleted;
  final bool isEditMode;
  final bool isLastItem;

  const TodoListItem({
    super.key,
    required this.inputState,
    this.reorderIndex,
    this.isCompleted = false,
    this.isEditMode = false,
    this.isLastItem = false,
    required this.onClick,
    required this.onTextChanged,
    required this.deleteClick,
    required this.actionClick,
  });

  @override
  State<StatefulWidget> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();

    _isCompleted = widget.isCompleted;
  }

  void setCompleted(bool isCompleted) {
    setState(() {
      _isCompleted = isCompleted;
    });
  }

  void onTextChanged(String text) {
    setState(() {
      widget.onTextChanged(text);
    });
  }

  Widget _buildTextField(bool isEditMode) {
    TextStyle textStyle = DsTextStyles.b1;
    if (_isCompleted && widget.inputState.controller.text.isNotEmpty == true) {
      textStyle = textStyle.copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: DsColorPalette.gray400,
        decorationThickness: 2.0,
        color: DsColorPalette.gray400,
      );
    } else {
      textStyle = textStyle.copyWith(color: DsColorPalette.gray800);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        cursorColor: DsColorPalette.black,
        controller: widget.inputState.controller,
        focusNode: widget.inputState.focusNode,
        style: textStyle,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onTap: widget.onClick,
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
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setCompleted(!_isCompleted);
                  widget.actionClick(_isCompleted);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 32,
                    top: 16,
                    bottom: 16,
                    right: 16,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isCompleted ? DsColorPalette.gray700 : Colors.transparent,
                      border: Border.all(
                        color: DsColorPalette.black,
                        width: 2.5,
                      ),
                    ),
                    width: 26,
                    height: 26,
                    child: AnimatedOpacity(
                      opacity: _isCompleted ? 1 : 0,
                      duration: Duration(milliseconds: 200),
                      child: DsImage(
                        Assets.svg.icCheck.path,
                        width: 22,
                        height: 22,
                        color: DsColorPalette.white,
                      ),
                    ),
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
                  if (!widget.isLastItem)
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
                  if (!widget.isLastItem && widget.reorderIndex != null)
                    ReorderableDragStartListener(
                      index: widget.reorderIndex!,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 32, top: 10, bottom: 10),
                        child: DsImage(
                          Assets.svg.icDragHandle.path,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    )
                ],
              ),
      ),
      bottomDivider: DashDivider(horizontalPadding: 32),
    );
  }
}
