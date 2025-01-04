import 'package:flutter/material.dart';
import 'package:presentation/ui/page/page_list_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todoit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          secondary: Colors.white,
        ),
        splashColor: Colors.transparent,
      ),
      home: PageListPage(title: 'todoit'),
    );
  }
}
