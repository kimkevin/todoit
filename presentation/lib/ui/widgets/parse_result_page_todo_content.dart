import 'package:flutter/cupertino.dart';
import 'package:presentation/ui/model/paeg_todo_parse_result.dart';
import 'package:presentation/ui/widgets/parse_result_page_todo_item.dart';

class ParseResultPageTodoContent extends StatefulWidget {
  final PageTodoParseResult result;

  const ParseResultPageTodoContent({
    super.key,
    required this.result,
  });

  @override
  State<StatefulWidget> createState() => ParseResultPageTodoContentState();
}

class ParseResultPageTodoContentState extends State<ParseResultPageTodoContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.result.pageTodos.map(
          (e) => ParseResultPageTodoItem(
            parsedPageTodo: e,
            onDataChanged: (result) {},
          ),
        ),
      ],
    );
  }
}
