import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/page/parse_todo_page.dart';

class InputItem extends StatefulWidget {
  final String name;
  final Function(String) onSubmit;

  final bool fromPage;

  const InputItem({
    super.key,
    required this.name,
    required this.onSubmit,
    required this.fromPage,
  });

  @override
  State<InputItem> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  void onTodoSubmitted(String name) {
    widget.onSubmit(name);
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
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: _textEditingController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '+클릭해서 ${widget.name} 추가하기',
                  hintStyle: DsTextStyles.item.copyWith(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
                ),
                style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                onSubmitted: onTodoSubmitted,
              ),
            ),
            if (widget.fromPage)
              GestureDetector(
                onTap: () {
                  context.navigator.push(MaterialPageRoute(builder: (context) => ParseTodoPage()));
                },
                child: Text('복붙'),
              ),
          ],
        ),
      );
}
