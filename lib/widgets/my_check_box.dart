import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final Function(bool value) onChage;
  final String text;

  MyCheckbox({super.key, required this.onChage, required this.text});
  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CheckboxListTile(
        title: Text(widget.text),
        value: isChecked,
        onChanged: (bool? value) {
          widget.onChage(value!);
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }
}
