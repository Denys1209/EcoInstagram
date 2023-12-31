import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/widgets/my_alert_dialog.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }

  print('No image selected');
}

showAlertDialog({
  required String title,
  required String text,
  required BuildContext context,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MyAlertDialog(
        text: text,
        title: title,
      );
    },
  );
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
