import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';
import 'package:presentation/ui/widgets/new_todo_item.dart';

class NewPageItem extends StatefulWidget {
  final NewPageItemUiModel newPage;
  final Function(String) onPageNameChanged;
  final Function(int, String) onTodoNameChanged;
  final Function(int) onTodoDeleted;

  const NewPageItem({
    super.key,
    required this.newPage,
    required this.onPageNameChanged,
    required this.onTodoNameChanged,
    required this.onTodoDeleted,
  });

  @override
  State<StatefulWidget> createState() => _NewPageItemState();
}

class _NewPageItemState extends State<NewPageItem> {
  late NewPageItemUiModel pageItemModel;
  late TextEditingController _nameController;
  final FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    print('new_page_item= ${widget.newPage}');

    pageItemModel = widget.newPage;
    _nameController = TextEditingController(text: widget.newPage.name);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageItemModel.autoFocus) {
        nameFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
          child: TextField(
            controller: _nameController,
            focusNode: nameFocusNode,
            style: DsTextStyles.title.copyWith(color: Color(0xFF242B34)),
            decoration: InputDecoration(
              hintText: '페이지 입력',
              hintStyle: DsTextStyles.title.copyWith(color: Color(0xFFC8C8C8)),
              border: InputBorder.none,
            ),
            onChanged: widget.onPageNameChanged,
          ),
        ),
        ...pageItemModel.todoItemModels.mapIndexed(
          (index, item) => NewTodoItem(
            newTodo: item,
            onTextChanged: (text) {
              widget.onTodoNameChanged(index, text);
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
