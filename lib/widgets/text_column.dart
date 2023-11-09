import 'package:flutter/widgets.dart';

class TextColumn extends StatelessWidget {
  final String text;
  const TextColumn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(text),
      ],
    );
  }
}
