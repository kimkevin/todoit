import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/gen/assets.gen.dart';

class NewTodoItem extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool deletable;
  final Function(String) onTextChanged;
  final VoidCallback onDeleteClick;

  const NewTodoItem({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onTextChanged,
    required this.onDeleteClick,
    this.deletable = false,
  });

  @override
  State<StatefulWidget> createState() => _NewTodoItemState();
}

class _NewTodoItemState extends State<NewTodoItem> {
  void onTextChanged(String text) {
    widget.onTextChanged(text);
  }

  Widget _buildTextField() {
    TextStyle textStyle = DsTextStyles.b1.copyWith(color: DsColorPalette.gray800);

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: textStyle,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: onTextChanged,
      decoration: InputDecoration(
        hintText: '할일 입력',
        hintStyle: textStyle.copyWith(color: DsColorPalette.gray300),
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
                    if (widget.deletable)
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
