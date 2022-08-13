import 'package:flutter/material.dart';

// Set a max width for the dialog or any widgets
@immutable
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    Key? key,
    this.maxWidth,
    required this.child,
  }) : super(key: key);

  final double? maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 500,
      ),
      child: child,
    );
  }
}
