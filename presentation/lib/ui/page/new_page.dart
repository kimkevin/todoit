import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/ds_image.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/new_page_notifier.dart';
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
  final List<TextEditingController> _todoNameControllers = [];

  @override
  void initState() {
    super.initState();

    _todoNameControllers.add(TextEditingController());
  }

  void _dismissKeyboard() {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus != null && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }

  void onActionClicked(NewPageNotifier notifier, bool isKeyboardVisible) {
    print('isKeyboardVisible= $isKeyboardVisible');
    if (isKeyboardVisible) {
      _dismissKeyboard();
      // TODO: 투두가 1개이고 아무것도 미입력이면 포커스를 옮겨준다
    } else {
      notifier.addTodo();

      FutureUtils.runDelayed(() {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
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
                    newPageNotifier.addTodos(text.split('\n'));
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
                final result =
                    await newPageNotifier.save(LocalizationUtils.getDefaultName(context));
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
                NewPageItem(
                  key: ValueKey(newPageNotifier.pageItemModel),
                  newPage: newPageNotifier.pageItemModel,
                  onPageNameChanged: newPageNotifier.changePageName,
                  onTodoNameChanged: newPageNotifier.changeTodoName,
                  onTodoDeleted: newPageNotifier.deleteTodo,
                ),
                SizedBox(height: 96),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: isKeyboardVisible ? 44.0 : 64.0,
          height: isKeyboardVisible ? 44.0 : 64.0,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            onPressed: () {
              onActionClicked(newPageNotifier, isKeyboardVisible);
            },
            child: DsImage(
              isKeyboardVisible ? Assets.svg.icCheck.path : Assets.svg.icPlus.path,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
