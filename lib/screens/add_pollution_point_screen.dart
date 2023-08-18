import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/providers/currect_location_provider.dart';

class AddScreenPollutionPoint extends StatefulWidget {
  const AddScreenPollutionPoint({super.key});

  @override
  State<AddScreenPollutionPoint> createState() =>
      _AddScreenPollutionPointState();
}

class _AddScreenPollutionPointState extends State<AddScreenPollutionPoint> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  Position? _currentPosition;
  bool _uploading = false;

  void postPoint(
    String uid,
    String username,
    String profImage,
  ) async {
    try {
      setState(() {
        _uploading = true;
      });
      _currentPosition = await CurrentLocationProvider().getCurrentLocation();
      String res = await FirestoreMethods().uploadPoint(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          _currentPosition!);
      if (res == "success") {
        showSnackBar("Posted", context);
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(_currentPosition.toString(), context);
    }
    setState(() {
      _uploading = false;
    });
    Navigator.of(context).pop();
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return !_uploading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => {
                    postPoint(user.uid, user.username, user.photoUrl),
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: _file != null
                                ? DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                        "https://images.unsplash.com/photo-1637775297509-19767f6fc225?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=627&q=80"),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _selectImage(context),
                      icon: const Icon(Icons.upload_file),
                    ),
                  ],
                )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
