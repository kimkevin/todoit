import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:presentation/ui/widgets/new_todo_item.dart';

class NewPageItem extends StatefulWidget {
  final TextEditingController pageNameController;
  final List<TextEditingController> todoNameControllers;
  final FocusNode? pageNameFocusNode;
  final FocusNode? firstTodoNameFocusNode;
  final bool lastItemDeletable;
  final VoidCallback? onLastItemChanged;
  final Function(int) onTodoDeleted;
  final Function(String)? onPageNameChanged;
  final Function(int, String)? onTodoNameChanged;
  final Function(String)? onPageNameSubmitted;

  NewPageItem({
    super.key,
    TextEditingController? pageNameController,
    List<TextEditingController>? todoNameControllers,
    this.pageNameFocusNode,
    this.firstTodoNameFocusNode,
    this.lastItemDeletable = false,
    this.onLastItemChanged,
    required this.onTodoDeleted,
    this.onPageNameChanged,
    this.onTodoNameChanged,
    this.onPageNameSubmitted,
  })  : pageNameController = pageNameController ?? TextEditingController(),
        todoNameControllers = todoNameControllers ?? [];

  @override
  State<StatefulWidget> createState() => _NewPageItemState();
}

class _NewPageItemState extends State<NewPageItem> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.pageNameFocusNode?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
          child: TextField(
            controller: widget.pageNameController,
            cursorColor: DsColorPalette.black,
            focusNode: widget.pageNameFocusNode,
            style: DsTextStyles.headline.copyWith(color: DsColorPalette.gray900),
            decoration: InputDecoration(
              hintText: '페이지 입력',
              hintStyle: DsTextStyles.headline.copyWith(color: DsColorPalette.gray300),
              border: InputBorder.none,
            ),
            onChanged: widget.onPageNameChanged,
            onSubmitted: widget.onPageNameSubmitted,
          ),
        ),
        ...widget.todoNameControllers.mapIndexed(
          (index, item) => NewTodoItem(
            controller: widget.todoNameControllers[index],
            focusNode: index == 0 ? widget.firstTodoNameFocusNode : null,
            deletable: widget.lastItemDeletable || index != widget.todoNameControllers.length - 1,
            onTextChanged: (text) {
              final isLastItem = index == widget.todoNameControllers.length - 1;
              if (isLastItem && text.isNotEmpty) {
                widget.onLastItemChanged?.call();
              }
              widget.onTodoNameChanged?.call(index, text);
            },
            onDeleteClick: () {
              widget.onTodoDeleted(index);
            },
          ),
        ),
      ],
    );
  }
}
