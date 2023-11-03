import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlrertDialogYesNo extends StatelessWidget {
  final String title;
  final String question;
  final String textOnYes;
  final String textOnNo;
  final Function()? onYesFunction;
  final Function()? onNoFunction;
  const AlrertDialogYesNo({
    super.key,
    required this.title,
    required this.question,
    required this.onYesFunction,
    required this.onNoFunction,
    required this.textOnNo,
    required this.textOnYes,
  });

  @override
  Widget build(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text(this.textOnYes),
      onPressed: () {
        if (onYesFunction != null) onYesFunction!();
        Navigator.of(context).pop();
      },
    );

    Widget noButton = TextButton(
      child: Text(this.textOnNo),
      onPressed: () {
        if (onNoFunction != null) onNoFunction!();
        Navigator.of(context).pop();
      },
    );

    return CupertinoAlertDialog(
      title: Text(this.title),
      content: Text(this.question),
      actions: [
        yesButton,
        noButton,
      ],
    );
  }
}
