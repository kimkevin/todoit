import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/new_page_notifier.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';
import 'package:presentation/ui/widgets/new_page_item.dart';
import 'package:presentation/ui/widgets/text_input_bottom_sheet.dart';
import 'package:presentation/utils/future_utils.dart';
import 'package:presentation/utils/localization_utils.dart';

class NewPage extends ConsumerStatefulWidget {
  const NewPage({super.key});

  @override
  ConsumerState<NewPage> createState() => _NewPageState();
}

class _NewPageState extends ConsumerState<NewPage> {
  final ScrollController _scrollController = ScrollController();
  final double _unscrollableHeight = 200;

  final List<TextEditingController> _pageNameControllers = [];
  final List<List<TextEditingController>> _todoNameControllersList = [];
  final List<NewPageItemUiModel> _pages = [];

  final FocusNode _pageNameFocusNode = FocusNode();
  final FocusNode _firstTodoNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _pages.add(NewPageItemUiModel(name: '', todoNames: ['']));

    for (var page in _pages) {
      _pageNameControllers.add(TextEditingController(text: page.name));
      _todoNameControllersList
          .add(page.todoNames.map((name) => TextEditingController(text: name)).toList());
    }
  }

  @override
  void dispose() {
    super.dispose();

    for (var controller in _pageNameControllers) {
      controller.dispose();
    }
    for (var todoControllers in _todoNameControllersList) {
      for (var controller in todoControllers) {
        controller.dispose();
      }
    }
  }

  void _dismissKeyboard() {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus != null && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }

  void _onLastItemChanged(int pageIndex) {
    setState(() {
      _todoNameControllersList[pageIndex].add(TextEditingController());
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    FutureUtils.runDelayed(() {
      _scrollController.animateTo(
        max(0, _scrollController.position.maxScrollExtent - _unscrollableHeight),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _addTodos(List<String> todoNames) {
    if (todoNames.isEmpty) return;

    setState(() {
      final todoNameControllers = _todoNameControllersList[0];
      final lastIndex = todoNameControllers.length - 1;
      if (todoNameControllers[lastIndex].text.isEmpty) {
        todoNames.forEachIndexed((index, name) {
          final controller = TextEditingController(text: name);
          if (index == 0) {
            todoNameControllers[lastIndex] = controller;
          } else {
            todoNameControllers.add(controller);
          }
        });
        todoNameControllers.add(TextEditingController());
      } else {
        todoNameControllers.addAll(
          todoNames.map((name) => TextEditingController(text: name)),
        );
      }
      _scrollToBottom();
    });
  }

  void _deleteTodo(int pageIndex, int todoIndex) {
    setState(() {
      _todoNameControllersList[pageIndex].removeAt(todoIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final newPageNotifier = ref.watch(newPageProvider);
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) => Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (context) => TextInputBottomSheet(),
                ).then((text) {
                  if (text is String) {
                    _addTodos(text.split('\n'));
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 36.0),
                child: Text(
                  'T',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!mounted) return;

                final result = await newPageNotifier.save(
                    _pageNameControllers.map((e) => e.text).toList(),
                    _todoNameControllersList
                        .map(
                          (list) => list
                              .sublist(0, list.length - 1)
                              .mapIndexed((index, controller) => controller.text)
                              .toList(),
                        )
                        .toList(),
                    LocalizationUtils.getDefaultName(context));
                context.navigator.pop(result);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: DsImage(Assets.svg.icCheck.path, width: 24, height: 24),
              ),
            )
          ],
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ..._pages.mapIndexed(
                  (index, page) => NewPageItem(
                    key: ValueKey(page),
                    pageNameController: _pageNameControllers[index],
                    todoNameControllers: _todoNameControllersList[index],
                    pageNameFocusNode: _pageNameFocusNode,
                    firstTodoNameFocusNode: _firstTodoNameFocusNode,
                    onLastItemChanged: () {
                      _onLastItemChanged(index);
                    },
                    onTodoDeleted: (todoIndex) {
                      _deleteTodo(index, todoIndex);
                    },
                    onPageNameSubmitted: (text) {
                      _firstTodoNameFocusNode.requestFocus();
                    },
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _dismissKeyboard,
                  child: SizedBox(
                    width: double.infinity,
                    height: _unscrollableHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
