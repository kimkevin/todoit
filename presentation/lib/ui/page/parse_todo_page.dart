import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/parser/page_todo_parser.dart';
import 'package:presentation/ui/model/paeg_todo_parse_result.dart';
import 'package:presentation/ui/widgets/parse_result_page_todo_content.dart';

class ParseTodoPage extends ConsumerStatefulWidget {
  const ParseTodoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ParseTodoPageState();
}

class _ParseTodoPageState extends ConsumerState<ParseTodoPage> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  late PageTodoParser parser;
  PageTodoParseResult? _parseResult;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    parser = PageTodoParser();
  }

  void onTodoSubmitted(String text) {
    setState(() {
      _parseResult = parser.parse(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _parseResult != null
              ? ParseResultPageTodoContent(result: _parseResult!)
              : Container(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '+텍스트 복사하기',
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.normal, fontSize: 24, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
                    ),
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24),
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // 제한 없이 여러 줄 입력 가능
                    onSubmitted: onTodoSubmitted,
                  ),
                ),
        ),
      ),
    );
  }
}
