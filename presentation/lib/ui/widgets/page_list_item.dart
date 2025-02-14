import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_ds/ui/widgets/ds_row.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/widgets/dash_divider.dart';
import 'package:presentation/utils/future_utils.dart';
import 'package:presentation/utils/localization_utils.dart';

class PageListItem extends StatefulWidget {
  final PageUiModel page;
  final int orderIndex;
  final bool isEditMode;
  final VoidCallback onClick;
  final VoidCallback onDeleteClick;
  final bool hasBottomBorder;
  final Function(String) onTextChanged;

  const PageListItem({
    super.key,
    required this.page,
    required this.orderIndex,
    required this.isEditMode,
    required this.onClick,
    required this.onDeleteClick,
    required this.onTextChanged,
    this.hasBottomBorder = true,
  });

  @override
  State<StatefulWidget> createState() => _PageListItemState();
}

class _PageListItemState extends State<PageListItem> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _controller = TextEditingController(text: widget.page.name);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void onTextChanged(String text) {
    widget.onTextChanged(text);
  }

  void onItemClick() {
    if (widget.isEditMode) {
      FutureUtils.runDelayed(() {
        _focusNode.requestFocus();
      });
    } else {
      widget.onClick.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditMode && widget.page.name.isEmpty) {
      _controller = TextEditingController(text: LocalizationUtils.getDefaultName(context));
    } else {
      _controller = TextEditingController(text: widget.page.name);
    }

    String countInfoText;
    if (widget.page.completionCount == widget.page.todoCount) {
      countInfoText = widget.page.completionCount.toString();
    } else {
      countInfoText =
          '${widget.page.completionCount.toString()}/${widget.page.todoCount.toString()}';
    }

    return DsRow(
      onClick: onItemClick,
      padding: EdgeInsets.only(left: 32),
      minHeight: 78,
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: IntrinsicWidth(
                child: TextField(
                  cursorColor: DsColorPalette.black,
                  onTap: onItemClick,
                  focusNode: _focusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  style: widget.page.completed
                      ? DsTextStyles.headline.copyWith(
                          color: DsColorPalette.gray400,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: DsColorPalette.gray400,
                          decorationThickness: 2.0,
                        )
                      : DsTextStyles.headline,
                  decoration: InputDecoration(
                    hintText: widget.isEditMode ? LocalizationUtils.getDefaultName(context) : '',
                    hintStyle: DsTextStyles.headline.copyWith(color: DsColorPalette.gray300),
                    border: InputBorder.none,
                  ),
                  readOnly: !widget.isEditMode,
                  onChanged: onTextChanged,
                ),
              ),
            ),
            if (!widget.isEditMode)
              Padding(
                padding: EdgeInsets.only(left: 12, bottom: 3),
                child: Text(
                  countInfoText,
                  style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray400),
                ),
              )
          ],
        ),
      ),
      trailing: Row(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: !widget.isEditMode
                ? SizedBox(width: 32)
                : Row(
                    children: [
                      InkWell(
                        onTap: widget.onDeleteClick,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                          child: DsImage(
                            Assets.svg.icTrash.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: widget.orderIndex,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 32, top: 10, bottom: 10),
                          child: DsImage(
                            Assets.svg.icDragHandle.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
      bottomDivider:
          widget.hasBottomBorder ? DashDivider(horizontalPadding: 32) : SizedBox.shrink(),
    );
  }
}
