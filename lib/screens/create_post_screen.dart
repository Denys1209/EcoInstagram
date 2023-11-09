import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/shape_button.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postController = TextEditingController();
  final _maxPostLen = 256;
  final _maxLines = 10;
  int _textLength = 0;

  @override
  void initState() {
    super.initState();
    _postController.addListener(() {
      setState(() {
        _textLength = _postController.text.length;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(style: TextStyle(fontWeight: FontWeight.bold), "Create post"),
            ShapeButton(
              text: "post",
              function: () =>  {
                 FirestoreMethods().uploadPost(
                 user.username,
                 _postController.text,
                 user.uid,
                 user.photoUrl,
                 ),
                 Navigator.of(context).pop()
              },
              textColor: Colors.white,
              backgroundColor: blueColor,
              borderColor: blueColor,
              width: MediaQuery.of(context).size.width * 0.2,
              borderRadius: 20,
              isEnabled: _textLength == 0 ? false : true,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                ),
                Text(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                    user.username),
              ],
            ),
            const Divider(thickness: 1),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your post',
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              maxLength: _maxPostLen,
              maxLines: _maxLines,
              controller: _postController,
            ),
          ],
        ),
      ),
    );
  }
}
