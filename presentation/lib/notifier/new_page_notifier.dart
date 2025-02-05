import 'package:collection/collection.dart';
import 'package:di/injection_container.dart';
import 'package:domain/model/new_page_model.dart';
import 'package:domain/model/new_todo_model.dart';
import 'package:domain/repository/page_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPageNotifier with ChangeNotifier {
  final PageRepository pageRepository;

  NewPageNotifier({required this.pageRepository});

  Future<bool> save(
    List<String> pageNames,
    List<List<String>> todoNamesList,
    String defaultName,
  ) =>
      pageRepository.createPageTodos(
        pageNames
            .mapIndexed(
              (index, name) => NewPageModel(
                name: name.isEmpty ? defaultName : name,
                todos: todoNamesList[index].map((name) => NewTodoModel(name: name)).toList(),
              ),
            )
            .toList(),
      );
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final newPageProvider = ChangeNotifierProvider.autoDispose<NewPageNotifier>(
  (ref) => NewPageNotifier(pageRepository: getIt<PageRepository>()),
);
