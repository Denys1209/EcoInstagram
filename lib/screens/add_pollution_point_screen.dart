import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:instagram_clone/widgets/photos_display_list.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/providers/currect_location_provider.dart';

class AddScreenPollutionPoint extends StatefulWidget {
  const AddScreenPollutionPoint({super.key});

  @override
  State<AddScreenPollutionPoint> createState() =>
      _AddScreenPollutionPointState();
}

class _AddScreenPollutionPointState extends State<AddScreenPollutionPoint> {
  List<Uint8List> _photos = List.empty(growable: true);
  final TextEditingController _descriptionController = TextEditingController();
  Position? _currentPosition;
  bool _uploading = false;

  void postPoint(
    String uid,
    String username,
    String profImage,
  ) async {
    if (_photos.length == 0) {
      showSnackBar("you must add a photo", context);
      return;
    }
    if (_descriptionController.text == null) _descriptionController.text = "";
    try {
      setState(() {
        _uploading = true;
      });
      _currentPosition = await CurrentLocationProvider().getCurrentLocation();
      String res = await FirestoreMethods().uploadPoint(
          _descriptionController.text,
          _photos[0],
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
          appBar: null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Align(
                    child: PhotosListDisplay(
                      canAddPhotos: true,
                      photos: _photos,
                      selectFormGallery: false,
                      canAddMoreThanOnePhoto: false,
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Type a description',
                    ),
                    maxLines: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                    child: FollowButton(
                      backgroundColor: Colors.black,
                      borderColor: Colors.white,
                      function: () {
                        postPoint(user.uid, user.username, user.photoUrl);
                      },
                      text: "create a new polution point",
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
