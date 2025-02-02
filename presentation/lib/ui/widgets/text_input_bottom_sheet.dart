import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_bottom_sheet_content.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/utils/future_utils.dart';

class TextInputBottomSheet extends StatefulWidget {
  const TextInputBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() => _TextInputBottomSheetState();
}

class _TextInputBottomSheetState extends State<TextInputBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    FutureUtils.runDelayed(() {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsBottomSheetContent(
      contents: [
        Container(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              context.navigator.pop(_controller.text);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, right: 24.0),
              child: DsImage(Assets.svg.icCheck.path, width: 24, height: 24),
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            style: DsTextStyles.b1.copyWith(height: 1.5),
            decoration: InputDecoration(
              hintText: '할일 입력\n할일 입력...',
              hintStyle: DsTextStyles.b1.copyWith(
                color: DsColorPalette.gray300,
                height: 1.5,
              ),
              border: InputBorder.none,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onChanged: (text) {},
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
