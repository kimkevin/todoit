import 'package:flutter/cupertino.dart';
import 'package:flutter_dash/flutter_dash.dart';

class DashDivider extends StatelessWidget {
  final int horizontalPadding;

  const DashDivider({
    super.key,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dash(
      length: screenWidth - horizontalPadding * 2,
      dashLength: 5,
      dashGap: 3,
      dashThickness: 1,
      dashColor: Color(0x66C8C8C8),
    );
  }
}
