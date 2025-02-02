import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_ds/foundation/color/ds_color_palete.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:presentation/gen/assets.gen.dart';

class TodoListItem extends StatefulWidget {
  final int? reorderIndex;
  final String text;
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
    required this.text,
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
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool isNew = false;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(text: widget.text);

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
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void onTextChanged(String text) {
    widget.onTextChanged(text);
  }

  Widget _buildTextField(bool isEditMode) {
    TextStyle textStyle;
    if (widget.isCompleted && _textController.text.isNotEmpty == true) {
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

    return TextField(
      controller: _textController,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                    AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: widget.isEditMode
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.actionClick();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
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
                    Expanded(
                      child:
                          // widget.isEditMode && widget.reorderIndex != null
                          //     ? ReorderableDragStartListener(
                          //         index: widget.reorderIndex!,
                          //         child: _buildTextField(widget.isEditMode, isCompleted),
                          //       )
                          //     :
                          _buildTextField(widget.isEditMode),
                    ),
                    AnimatedOpacity(
                      opacity: widget.isEditMode ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: widget.deleteClick,
                            child: Padding(
                              padding: EdgeInsets.only(right: 29),
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
                              child: DsImage(
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
}
