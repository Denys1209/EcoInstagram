import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/shape_button.dart';
import 'package:instagram_clone/widgets/photos_display_list.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CreateEventCleanScreen extends StatefulWidget {
  final LatLng? point;
  final List<String> pollutionPointsIds;
  const CreateEventCleanScreen({
    super.key,
    required this.point,
    required this.pollutionPointsIds,
  });

  @override
  State<CreateEventCleanScreen> createState() => _CreateEventCleanScreenState();
}

class _CreateEventCleanScreenState extends State<CreateEventCleanScreen> {
  final List<Uint8List> _photos = List.empty(growable: true);
  final List<String> _urls = List.empty(growable: true);
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _eventName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
    _eventName.dispose();
  }

  Future<Uint8List> downloadImageAsBytes(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image.');
    }
  }

  _photosFromUrls() async {
    _urls.addAll(await FirestoreMethods()
        .getAllUrlsFromListOfPolltuionsID(widget.pollutionPointsIds));
    for (var url in _urls) {
      Uint8List photo = await downloadImageAsBytes(url);
      setState(() {
        _photos.add(photo);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _photosFromUrls();
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
                canAddPhotos: false,
                photos: _photos,
                selectFormGallery: true,
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
                    icon: const Icon(Icons.access_time),
                  ),
                  Text(
                    '${_selectedTime.hour}:${_selectedTime.minute}',
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
              child: (_description.text != null)
                  ? ShapeButton(
                      backgroundColor: Colors.black,
                      borderColor: Colors.white,
                      function: () {
                        _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime.hour,
                            _selectedTime.minute);
                        FirestoreMethods().uploadEventClean(
                          _eventName.text,
                          _selectedDate,
                          widget.point!.latitude,
                          widget.point!.longitude,
                          _description.text,
                          user.uid,
                          _urls,
                          widget.pollutionPointsIds,
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
