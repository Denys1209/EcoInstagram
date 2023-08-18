import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:instagram_clone/widgets/my_mark.dart';
import 'package:latlong2/latlong.dart';

class mapScreen extends StatefulWidget {
  const mapScreen({super.key});

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  List<Marker> _marks = List.empty(growable: true);
  List<Marker> _events = List.empty(growable: true);
  bool _loadEnd = false;

  _getMarks() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('pollutionPoints');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      _marks.add(
        Marker(
            point: LatLng(snap["LAT"] as double, snap["LNG"] as double),
            builder: (context) {
              return my_mark(snap: snap);
            },
            width: 30,
            height: 30),
      );
    }
  }

  _getEvents() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('events');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      _events.add(
        Marker(
            point: LatLng(snap["LAT"] as double, snap["LNG"] as double),
            builder: (context) {
              return my_mark(snap: snap);
            },
            width: 30,
            height: 30),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMarks();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(37, -122),
        zoom: 0,
        maxZoom: 22,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          maxZoom: 22,
          userAgentPackageName: 'com.example.instagram_clone',
        ),
        MarkerLayer(markers: _marks)
      ],
    );
  }
}
