import 'dart:typed_data';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:instagram_clone/widgets/photos_display_list.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

class CreateEventScreen extends StatefulWidget {
  final LatLng? point;

  const CreateEventScreen({
    super.key,
    required this.point,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  List<Uint8List> _photos = List.empty(growable: true);
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
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
                selectFormGallery: true,
                canAddMoreThanOnePhoto: true,
              ),
            ),
            DateTimePicker(
              initialValue: '',
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              dateLabelText: 'Date',
              onChanged: (String val) {
                setState(() {
                  _selectedDate = DateTime.parse(val);
                });
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? newTime = (await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      ))!;
                      if (newTime == null) return;

                      setState(() {
                        _selectedTime = newTime;
                      });
                    },
                    icon: Icon(Icons.access_time),
                  ),
                  Text(
                    '${_selectedTime.hour}:${_selectedTime.minute}',
                  ),
                ],
              ),
            ),
            TextField(
              controller: _controller,
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
                  _selectedDate = new DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute);

                  FirestoreMethods().uploadEvent(
                    _selectedDate,
                    widget.point!.latitude,
                    widget.point!.longitude,
                    _controller.text,
                    user.uid,
                    _photos,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MobileScreenLayout(),
                    ),
                  );
                },
                text: "create a new event",
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
