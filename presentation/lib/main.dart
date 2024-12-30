import 'package:di/injection_container.dart';
import 'package:domain/repository/page_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/app.dart';
import 'package:presentation/exceptions/initialization_failure_exception.dart';

Future<bool> initializeApp() => getIt<PageRepository>().initBasicPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();

  final isBasicPageNotExisted = await initializeApp();
  if (!isBasicPageNotExisted) {
    throw InitializationFailureException();
  }

  runApp(ProviderScope(child: MyApp()));
}
