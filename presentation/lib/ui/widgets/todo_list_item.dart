import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
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
  final Function(int, String)? saveCallback;
  final bool isEditMode;

  const TodoListItem({
    super.key,
    this.reorderIndex,
    this.todo,
    this.isEditMode = true,
    this.deleteClick,
    this.actionClick,
    this.saveCallback,
  });

  @override
  State<StatefulWidget> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.todo?.name);

    _focusNode.addListener(() {
      final newName = _textController.text;
      if (!_focusNode.hasFocus && widget.todo?.name != newName) {
        final id = widget.todo?.id;
        if (id != null) {
          widget.saveCallback?.call(id, newName);
        }
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompleted = widget.todo?.completed == true;

    return IntrinsicHeight(
      child: Container(
        constraints: BoxConstraints(minHeight: 74, maxHeight: double.infinity),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.actionClick == null) return;
                        HapticFeedback.lightImpact();
                        if (widget.todo != null) {
                          widget.actionClick!(widget.todo!);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: widget.todo?.completed == true
                            ? SvgPicture.asset(
                                Assets.svg.icCheck.path,
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(Color(0xFFFF8794), BlendMode.srcIn),
                              )
                            : SvgPicture.asset(
                                Assets.svg.icCircle.path,
                                width: 24,
                                height: 24,
                              ),
                      ),
                    ),
                    Expanded(
                      child:
                          // widget.isEditMode && widget.reorderIndex != null
                          //     ? ReorderableDragStartListener(
                          //         index: widget.reorderIndex!,
                          //         child: _buildTextField(widget.isEditMode, isCompleted),
                          //       )
                          //     :
                          _buildTextField(widget.isEditMode, isCompleted),
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
                                  child: SvgPicture.asset(
                                    Assets.svg.icTrash.path,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              )),
                          if (widget.reorderIndex != null)
                            ReorderableDragStartListener(
                              index: widget.reorderIndex!,
                              child: SvgPicture.asset(
                                Assets.svg.icDragHandle.path,
                                width: 24,
                                height: 24,
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 32,
              right: 32,
              child: Dash(
                length: screenWidth - 64,
                dashLength: 5,
                dashGap: 3,
                dashThickness: 1,
                dashColor: Color(0x9E9FA080),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(bool isEditMode, bool isCompleted) {
    TextStyle textStyle;
    if (isCompleted) {
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
      textStyle = DsTextStyles.todo.copyWith(color: Color(0xFF242B34));
    }

    return TextField(
      controller: _textController,
      style: textStyle,
      focusNode: _focusNode,
      // enabled: isEditMode,
      decoration: InputDecoration(
        hintText: '할일 입력',
        hintStyle: DsTextStyles.todo.copyWith(color: Color(0xFFC8C8C8)),
        border: InputBorder.none,
      ),
    );
  }
}
