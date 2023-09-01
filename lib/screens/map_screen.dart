import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/clean_event_mark.dart';
import 'package:instagram_clone/widgets/event_mark.dart';
import 'package:instagram_clone/widgets/pollution_point_mark.dart';
import 'package:latlong2/latlong.dart';

class mapScreen extends StatefulWidget {
  const mapScreen({super.key});

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  List<Marker> _pollutionPoints = List.empty(growable: true);
  List<Marker> _events = List.empty(growable: true);
  List<Marker> _cleanEvents = List.empty(growable: true);
  bool _loadEnd = false;
  String _dropdownValue = 'Pollution points';

  _getMarks() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('pollutionPoints');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Marker> marks = List.empty(growable: true);
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      setState(() {
        marks.add(
          Marker(
              point: LatLng(snap["LAT"] as double, snap["LNG"] as double),
              builder: (context) {
                return PollutionPointMark(snap: snap);
              },
              width: 30,
              height: 30),
        );
      });
    }
    setState(() {
      _pollutionPoints = marks;
    });
  }

  _getEvents() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('events');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Marker> events = List.empty(growable: true);
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      setState(() {
        events.add(
          Marker(
              point: LatLng(snap["LAT"] as double, snap["LNG"] as double),
              builder: (context) {
                return EventMark(snap: snap);
              },
              width: 30,
              height: 30),
        );
      });
    }
    setState(() {
      _events = events;
    });
  }

  _getCleanEvents() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('cleanEvents');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Marker> events = List.empty(growable: true);
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      setState(() {
        events.add(
          Marker(
              point: LatLng(snap["LAT"] as double, snap["LNG"] as double),
              builder: (context) {
                return CleanEventMark(snap: snap);
              },
              width: 30,
              height: 30),
        );
      });
    }
    setState(() {
      _cleanEvents = events;
    });
  }

  _getSelectedMarks() {
    if (_dropdownValue == "Pollution points")
      return _pollutionPoints;
    else if (_dropdownValue == "Events")
      return _events;
    else
      return _cleanEvents;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMarks();
    _getEvents();
    _getCleanEvents();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(37, -122),
              zoom: 13,
              maxZoom: 22,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                maxZoom: 22,
                userAgentPackageName: 'com.example.instagram_clone',
              ),
              MarkerLayer(markers: _getSelectedMarks())
            ],
          ),
          // DropdownButton widget
          Positioned(
              top: 10.0,
              left: 10.0,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                ),
                child: DropdownButton<String>(
                  value: _dropdownValue,
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: blueColor,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: blueColor,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Pollution points', 'Events', 'Clean events']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: blueColor),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }
}
