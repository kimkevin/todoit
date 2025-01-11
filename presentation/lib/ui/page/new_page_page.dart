import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/widgets/todo_list_item.dart';

class NewPagePage extends ConsumerStatefulWidget {
  const NewPagePage({super.key});

  @override
  ConsumerState<NewPagePage> createState() => _NewPagePageState();
}

class _NewPagePageState extends ConsumerState<NewPagePage> {
  late TextEditingController _pageNameController;
  late TextEditingController _todoInputController;
  List<TextEditingController> _todoNameControllers = [];
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _pageNameController = TextEditingController();
    _todoInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
                child: TextField(
                  controller: _pageNameController,
                  style: DsTextStyles.title.copyWith(color: Color(0xFF242B34)),
                  decoration: InputDecoration(
                    hintText: '페이지 입력',
                    hintStyle: DsTextStyles.title.copyWith(color: Color(0xFFC8C8C8)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              TodoListItem(),
            ],
          ),
        ),
      ),
    );
  }
}
