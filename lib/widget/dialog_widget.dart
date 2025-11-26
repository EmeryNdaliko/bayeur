import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final Widget child;
  const DialogWidget({super.key, required this.child});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        // width: 500,
        height: 500,
        child: widget.child,
      ),
    );
  }
}
