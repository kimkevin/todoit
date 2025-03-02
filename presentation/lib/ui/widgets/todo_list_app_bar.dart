import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_appbar_action.dart';
import 'package:presentation/gen/assets.gen.dart';

class TodoListAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String pageName;
  final double titleHeight;
  final double progressHeight;
  final double completionRate;
  final bool isEditMode;
  final ScrollController scrollController;
  final VoidCallback onEditModeClick;

  const TodoListAppBar({
    super.key,
    required this.pageName,
    required this.titleHeight,
    required this.progressHeight,
    required this.completionRate,
    required this.isEditMode,
    required this.scrollController,
    required this.onEditModeClick,
  });

  @override
  State<StatefulWidget> createState() => _TodoListAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TodoListAppBarState extends State<TodoListAppBar> {
  bool _isAppBarTitleVisible = false;
  bool _isAppBarProgressVisible = false;
  Timer? _throttle;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateOpacity);
  }

  @override
  void dispose() {
    super.dispose();

    _throttle?.cancel();
    widget.scrollController.removeListener(_updateOpacity);
  }

  void _updateOpacity() {
    if (_throttle?.isActive ?? false) return;

    _throttle = Timer(Duration(milliseconds: 100), () {
      double offset = widget.scrollController.offset;
      final isAppBarTitleVisible = offset >= widget.titleHeight;
      final isAppBarProgressVisible = offset >= widget.titleHeight + widget.progressHeight;
      if (widget.titleHeight > 0) {
        if (_isAppBarTitleVisible != isAppBarTitleVisible ||
            _isAppBarProgressVisible != isAppBarProgressVisible) {
          setState(() {
            _isAppBarTitleVisible = isAppBarTitleVisible;
            _isAppBarProgressVisible = isAppBarProgressVisible;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Visibility(
          visible: _isAppBarTitleVisible ? true : false,
          child: Text(
            widget.pageName,
            style: DsTextStyles.b2.copyWith(color: DsColorPalette.gray900),
          ),
        ),
      ),
      actions: [
        Visibility(
          visible: _isAppBarProgressVisible ? true : false,
          child: Row(
            children: [
              AnimatedDigitWidget(
                key: ValueKey(widget.completionRate),
                value: (widget.completionRate * 100).round(),
                textStyle: DsTextStyles.b3.copyWith(color: DsColorPalette.gray900),
              ),
              Text(
                '%',
                style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray900),
              )
            ],
          ),
        ),
        DsAppBarAction(
          type: AppBarActionType.image,
          imagePath: widget.isEditMode ? Assets.svg.icCheck.path : Assets.svg.icEdit.path,
          onTap: widget.onEditModeClick,
        ),
      ],
    );
  }
}
