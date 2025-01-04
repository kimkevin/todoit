import 'package:flutter/material.dart';
import 'package:presentation/ui/model/paeg_todo_parse_result.dart';

class ParseResultPageTodoItem extends StatefulWidget {
  final ParsedPageTodo parsedPageTodo;
  final ValueChanged<ParsedPageTodo> onDataChanged;

  const ParseResultPageTodoItem({
    super.key,
    required this.parsedPageTodo,
    required this.onDataChanged,
  });

  @override
  State<StatefulWidget> createState() => _ParseResultPageTodoItemState();
}

class _ParseResultPageTodoItemState extends State<ParseResultPageTodoItem> {
  late TextEditingController _pageNameController;
  late List<TextEditingController> _todoNameControllers;

  @override
  void initState() {
    super.initState();

    _pageNameController = TextEditingController(text: widget.parsedPageTodo.pageName);
    _todoNameControllers =
        widget.parsedPageTodo.todoNames.map((e) => TextEditingController(text: e)).toList();
  }

  @override
  void dispose() {
    _pageNameController.dispose();
    for (var controller in _todoNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateTodos() {
    final updatedPageTodo = ParsedPageTodo(
      pageName: _pageNameController.text,
      todoNames: _todoNameControllers.map((e) => e.text).toList(),
    );
    widget.onDataChanged(updatedPageTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _pageNameController,
          decoration: InputDecoration(
            // labelText: 'Page Name',
            // border: OutlineInputBorder(),
            border: InputBorder.none,
          ),
          onChanged: (value) => _updateTodos(),
        ),
        const SizedBox(height: 16),
        ..._todoNameControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // labelText: 'Todo ${index + 1}',
                      // border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _updateTodos(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _todoNameControllers.removeAt(index);
                      _updateTodos();
                    });
                  },
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _todoNameControllers.add(TextEditingController());
              _updateTodos();
            });
          },
          icon: Icon(Icons.add),
          label: Text('Add Todo'),
        ),
      ],
    );
  }
}
