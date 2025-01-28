import 'package:di/injection_container.dart';
import 'package:domain/repository/page_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';

class NewPageNotifier with ChangeNotifier {
  final PageRepository pageRepository;

  NewPageItemModel pageItemModel = NewPageItemModel(
    todoItemModels: [NewTodoItemModel(autoFocus: true)],
    autoFocus: true,
  );

  NewPageNotifier({required this.pageRepository});

  void changePageName(String name) {
    pageItemModel = pageItemModel.copyWith(
      name: name,
      autoFocus: false,
    );
  }

  void changeTodoName(int index, String name) {
    final newTodoItemModels = [...pageItemModel.todoItemModels];
    newTodoItemModels[index] = NewTodoItemModel(name: name);
    pageItemModel = pageItemModel.copyWith(
      autoFocus: false,
      todoItemModels: newTodoItemModels,
    );
  }

  void addTodo() {
    pageItemModel = pageItemModel.copyWith(
      autoFocus: false,
      todoItemModels: [...pageItemModel.todoItemModels, NewTodoItemModel()],
    );
    notifyListeners();
  }

  void deleteTodo(int index) {
    final newTodoItemModels = [...pageItemModel.todoItemModels];
    newTodoItemModels.removeAt(index);

    pageItemModel = pageItemModel.copyWith(
      autoFocus: false,
      todoItemModels: newTodoItemModels,
    );
    notifyListeners();
  }

  Future<bool> save(String defaultName) async {
    String name = pageItemModel.name;
    if (name.isEmpty) {
      name = defaultName;
    }
    return await pageRepository.createPageTodos(
      name,
      pageItemModel.todoItemModels.map((e) => e.name).toList(),
    );
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final newPageProvider = ChangeNotifierProvider.autoDispose<NewPageNotifier>(
  (ref) => NewPageNotifier(pageRepository: getIt<PageRepository>()),
);
