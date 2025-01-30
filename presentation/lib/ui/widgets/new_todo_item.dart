import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/model/new_todo_item_model.dart';

class NewTodoItem extends StatefulWidget {
  final NewTodoItemUiModel newTodo;
  final Function(String) onTextChanged;
  final VoidCallback onDeleteClick;

  const NewTodoItem({
    super.key,
    required this.newTodo,
    required this.onTextChanged,
    required this.onDeleteClick,
  });

  @override
  State<StatefulWidget> createState() => _NewTodoItemState();
}

class _NewTodoItemState extends State<NewTodoItem> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(text: widget.newTodo.name);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (isNew) {
      //   _focusNode.requestFocus();
      // widget.onNewTodoFocused?.call();
      // isNew = false;
      // }
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

  Widget _buildTextField() {
    TextStyle textStyle = DsTextStyles.todo.copyWith(color: Color(0xFF242B34));

    return TextField(
      controller: _textController,
      style: textStyle,
      focusNode: _focusNode,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      // textInputAction: TextInputAction.done,
      onChanged: onTextChanged,
      decoration: InputDecoration(
        hintText: '할일 입력',
        hintStyle: DsTextStyles.todo.copyWith(color: Color(0xFFC8C8C8)),
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
                    Expanded(
                      child: _buildTextField(),
                    ),
                    InkWell(
                      onTap: widget.onDeleteClick,
                      child: SvgPicture.asset(
                        Assets.svg.icTrash.path,
                        width: 24,
                        height: 24,
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
