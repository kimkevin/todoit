import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/ui/widgets/ds_appbar_action.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/new_parsed_page_notifier.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';
import 'package:presentation/ui/widgets/new_page_item.dart';
import 'package:presentation/utils/localization_utils.dart';

class NewParsedPage extends ConsumerStatefulWidget {
  final List<NewPageItemUiModel> newPageItems;

  const NewParsedPage({
    super.key,
    required this.newPageItems,
  });

  @override
  ConsumerState<NewParsedPage> createState() => _NewParsedPageState();
}

class _NewParsedPageState extends ConsumerState<NewParsedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(newParsedPageProvider).load(widget.newPageItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(newParsedPageProvider);
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) => Scaffold(
        appBar: AppBar(
          actions: [
            DsAppBarAction(
              type: AppBarActionType.image,
              imagePath: Assets.svg.icCheck.path,
              onTap: () async {
                if (!mounted) return;
                final result = await notifier.save(LocalizationUtils.getDefaultName(context));
                context.navigator.pop(result);
              },
            ),
          ],
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ...notifier.newPageItems.mapIndexed(
                  (index, page) => Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: NewPageItem(
                      key: ValueKey(page),
                      pageNameController: TextEditingController(text: page.name),
                      todoNameControllers: page.todoNames
                          .map(
                            (name) => TextEditingController(text: name),
                          )
                          .toList(),
                      lastItemDeletable: true,
                      onPageNameChanged: (text) {
                        notifier.changePageName(index, text);
                      },
                      onTodoNameChanged: (todoIndex, text) {
                        notifier.changeTodoName(index, todoIndex, text);
                      },
                      onTodoDeleted: (todoIndex) {
                        notifier.deleteTodo(index, todoIndex);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 96),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
