import 'dart:typed_data';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/shape_button.dart';
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
  final List<Uint8List> _photos = List.empty(growable: true);
  DateTime _selectedStartDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _eventName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
    _eventName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _eventName,
          decoration: const InputDecoration(
            labelText: 'Type event\'s name',
          ),
        ),
      ),
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
              dateLabelText: 'Start date',
              onChanged: (String val) {
                setState(() {
                  _selectedStartDate = DateTime.parse(val);
                });
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Text("start date"),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? newTime = (await showTimePicker(
                        context: context,
                        initialTime: _selectedStartTime,
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
                        _selectedStartTime = newTime;
                      });
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                  Text(
                    '${_selectedStartTime.hour}:${_selectedStartTime.minute}',
                  ),
                ],
              ),
            ),
            DateTimePicker(
              initialValue: '',
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              dateLabelText: 'End date',
              onChanged: (String val) {
                setState(() {
                  _selectedEndDate = DateTime.parse(val);
                });
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Text("end date"),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? newTime = (await showTimePicker(
                        context: context,
                        initialTime: _selectedEndTime,
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
                        _selectedEndTime = newTime;
                      });
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                  Text(
                    '${_selectedEndTime.hour}:${_selectedEndTime.minute}',
                  ),
                ],
              ),
            ),
            TextField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Type a description',
              ),
              maxLines: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: (_eventName.text != null)
                  ? ShapeButton(
                      backgroundColor: Colors.black,
                      borderColor: Colors.blue,
                      function: () {
                        _selectedStartDate = DateTime(
                          _selectedStartDate.year,
                          _selectedStartDate.month,
                          _selectedStartDate.day,
                          _selectedStartTime.hour,
                          _selectedStartTime.minute,
                        );
                        _selectedEndDate = DateTime(
                          _selectedEndDate.year,
                          _selectedEndDate.month,
                          _selectedEndDate.day,
                          _selectedEndTime.hour,
                          _selectedEndTime.minute,
                        );

                        FirestoreMethods().uploadEvent(
                          _eventName.text,
                          _selectedStartDate,
                          _selectedEndDate,
                          widget.point!.latitude,
                          widget.point!.longitude,
                          _description.text,
                          user.uid,
                          _photos,
                          user.username,
                          user.photoUrl,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MobileScreenLayout(),
                          ),
                        );
                      },
                      text: "create a new event",
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.8,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
