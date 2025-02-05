import 'package:di/injection_container.dart';
import 'package:domain/repository/page_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';

class NewParsedPageNotifier with ChangeNotifier {
  final PageRepository pageRepository;

  List<NewPageItemUiModel> _newPageItems = [];

  List<NewPageItemUiModel> get newPageItems => List.unmodifiable(_newPageItems);

  NewParsedPageNotifier({required this.pageRepository});

  void load(List<NewPageItemUiModel> newPageItems) {
    _newPageItems = newPageItems;
    notifyListeners();
  }

  void changePageName(int pageIndex, String name) {
    final newPage = _newPageItems[pageIndex];
    // _newPageItems = List<NewPageItemUiModel>.from(_newPageItems)
    // ..[pageIndex] = newPage.copyWith(name: name);
  }

  void changeTodoName(int pageIndex, int todoIndex, String name) {
    final newPage = _newPageItems[pageIndex];
    // final newTodoItemModels = List<NewTodoItemUiModel>.from(newPage.todoItemModels)
    //   ..[todoIndex] = NewTodoItemUiModel(name: name);
    //
    // _newPageItems = List<NewPageItemUiModel>.from(_newPageItems)
    // ..[pageIndex] = newPage.copyWith(todoItemModels: newTodoItemModels);
  }

  void deleteTodo(int pageIndex, int todoIndex) {
    final newPage = _newPageItems[pageIndex];
    // final newTodoItemModels = List<NewTodoItemUiModel>.from(newPage.todoItemModels)
    //   ..removeAt(todoIndex);

    // _newPageItems = List<NewPageItemUiModel>.from(_newPageItems)
    //   ..[pageIndex] = newPage.copyWith(todoItemModels: newTodoItemModels);
    notifyListeners();
  }

  Future<bool> save(String defaultName) async {
    // final newPages = _newPageItems.map((itemModel) {
    //   String name = itemModel.name;
    //   if (name.isEmpty) {
    //     name = defaultName;
    //   }
    //   return NewPageModel(
    //     name: name,
    //     todos: itemModel.todoItemModels.map((e) => NewTodoModel(name: e.name)).toList(),
    //   );
    // }).toList();

    // return await pageRepository.createPageTodos(newPages);
    return true;
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final newParsedPageProvider = ChangeNotifierProvider.autoDispose<NewParsedPageNotifier>(
  (ref) => NewParsedPageNotifier(pageRepository: getIt<PageRepository>()),
);
