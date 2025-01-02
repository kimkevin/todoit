import 'package:flutter/material.dart';
import 'package:presentation/ui/model/page.dart';

class PageListItem extends StatelessWidget {
  final PageUiModel page;
  final Function(PageUiModel) onClick;

  const PageListItem({
    super.key,
    required this.page,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(page);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                page.name,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
