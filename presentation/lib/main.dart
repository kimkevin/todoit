import 'package:di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/ui/app.dart';

// Future<bool> initializeApp() => getIt<PageRepository>().initBasicPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();

  // final isBasicPageNotExisted = await initializeApp();
  // if (!isBasicPageNotExisted) {
  //   throw InitializationFailureException();
  // }

  runApp(ProviderScope(child: MyApp()));
}
