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
      child: Text(textOnYes),
      onPressed: () {
        if (onYesFunction != null)
          onYesFunction!();
        else
          Navigator.of(context).pop();
      },
    );

    Widget noButton = TextButton(
      child: Text(textOnNo),
      onPressed: () {
        if (onNoFunction != null)
          onNoFunction!();
        else
          Navigator.of(context).pop();
      },
    );

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(question),
      actions: [
        yesButton,
        noButton,
      ],
    );
  }
}
