import 'package:flutter/material.dart';

class TodoInputItem extends StatefulWidget {
  final Function(String) onTodoSubmitted;

  const TodoInputItem({super.key, required this.onTodoSubmitted});

  @override
  State<TodoInputItem> createState() => _TodoInputItemState();
}

class _TodoInputItemState extends State<TodoInputItem> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  void onTodoSubmitted(String name) {
    widget.onTodoSubmitted(name);
    _textEditingController.clear();
    _focusNode.unfocus();
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        textInputAction: TextInputAction.done,
        controller: _textEditingController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          isDense: true,
          hintText: '+클릭해서 추가하기',
          hintStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 24, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
        ),
        style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        onSubmitted: onTodoSubmitted,
      ),
    );
  }
}
