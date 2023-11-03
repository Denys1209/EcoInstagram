import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:instagram_clone/models/pollution_point.dart';
import 'package:instagram_clone/widgets/pollution_point_mark.dart';
import 'package:latlong2/latlong.dart';

class MapScreenForCleanEvent extends StatefulWidget {
  late List<String> polltuionPointsIds = List.empty(growable: true);
  MapScreenForCleanEvent({super.key, required this.polltuionPointsIds});

  @override
  State<MapScreenForCleanEvent> createState() => _MapScreenForCleanEventState();
}

class _MapScreenForCleanEventState extends State<MapScreenForCleanEvent> {
  List<Marker> _pollutionPoints = List.empty(growable: true);
  bool _isLoading = true;
  _getMarks() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('pollutionPoints');
    QuerySnapshot querySnapshot = await _collectionRef
        .where(FieldPath.documentId, whereIn: widget.polltuionPointsIds)
        .get();
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
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMarks();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
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
                    MarkerLayer(markers: _pollutionPoints)
                  ],
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
