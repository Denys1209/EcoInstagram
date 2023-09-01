import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/utils/utils.dart';

class PhotosListDisplay extends StatefulWidget {
  List<Uint8List> photos = List.empty(growable: true);
  final bool canAddPhotos;
  final bool selectFormGallery;
  final bool canAddMoreThanOnePhoto;
  PhotosListDisplay({
    super.key,
    required this.photos,
    required this.selectFormGallery,
    required this.canAddPhotos,
    this.canAddMoreThanOnePhoto = true,
  });

  @override
  State<PhotosListDisplay> createState() => _PhotosListDisplayState();
}

class _PhotosListDisplayState extends State<PhotosListDisplay> {
  late Uint8List _selectPhoto;
  int _index = 0;
  _getFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        final file = File(pickedFile.path).readAsBytesSync();
        widget.photos.add(file);
        _selectPhoto = file;
        _index = widget.photos.indexOf(widget.photos.last);
      });
    }
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Which source to select'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  widget.photos.add(file);
                  _selectPhoto = file;
                  _index = widget.photos.indexOf(widget.photos.last);
                });
              },
            ),
            widget.selectFormGallery
                ? SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: const Text("select from gallery"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _getFromGallery();
                    },
                  )
                : Container(),
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
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: widget.photos.isEmpty
              ? BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: Colors.grey,
                  ),
                )
              : BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(widget.photos[_index]),
                    fit: BoxFit.cover,
                  ),
                ),
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                setState(() {
                  _index += 1;
                  if (_index >= widget.photos.length) {
                    _index = 0;
                  }
                });
                // Swiped to the right
                // Perform your action here
              } else if (details.primaryVelocity! < 0) {
                _index -= 1;
                if (_index < 0) {
                  _index = widget.photos.length - 1;
                }
                // Swiped to the left
                // Perform your action here
              }
            },
          ),
        ),
        widget.canAddPhotos &&
                (widget.canAddMoreThanOnePhoto || widget.photos.length < 1)
            ? Align(
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 27,
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    _selectImage(context);
                  },
                ),
              )
            : Container(),
        Positioned(
          top: 0,
          right: 0,
          child: widget.photos.isEmpty
              ? Text('')
              : Text(
                  '${_index + 1}/${widget.photos.length}',
                  style: TextStyle(
                    backgroundColor: Color.fromRGBO(211, 211, 211, 0.6),
                  ),
                ),
        ),
      ],
    );
  }
}
