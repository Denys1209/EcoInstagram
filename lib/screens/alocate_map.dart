import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:instagram_clone/screens/create_clean_event_screen.dart';
import 'package:instagram_clone/widgets/highlight_mark.dart';
import 'package:latlong2/latlong.dart';

class AlocateMap extends StatefulWidget {
  late LatLng point;
  AlocateMap({
    super.key,
    required this.point,
  });

  @override
  State<AlocateMap> createState() => AalocateMapState();
}

class AalocateMapState extends State<AlocateMap> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pollutionPoints');

  List<Marker> _marks = List.empty(growable: true);
  List<String> _highlights = List.empty(growable: true);
  bool _loadEnd = false;

  Widget _buildFlagMarker(BuildContext context) {
    return Container(
      width: 30,
      height: 50,
      child: const Icon(
        Icons.flag,
        color: Colors.blue,
        size: 40,
      ),
    );
  }

  _getMarks() async {
    QuerySnapshot querySnapshot = await _collectionRef.where('eventId', isEqualTo: "").get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      setState(() {
        _marks.add(
          Marker(
            point: LatLng(snap['LAT'], snap['LNG']),
            builder: (context) {
              return HighlightMark(
                onChanged: () => setState(
                  () {
                    if (!_highlights.contains(snap['postId'])) {
                      _highlights.add(snap['postId']);
                    } else {
                      _highlights.remove(snap['postId']);
                    }
                  },
                ),
              );
            },
            width: 30,
            height: 50,
          ),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(widget.point.latitude, widget.point.longitude),
            zoom: 13,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 40,
                  height: 80,
                  point: widget.point,
                  builder: (ctx) => _buildFlagMarker(ctx),
                ),
                ..._marks.map((mark) {
                  return mark;
                }).toList(),
              ],
            ),
          ],
        ),
        _highlights.length != 0
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEventCleanScreen(
                            point: widget.point,
                            pollutionPointsIds: _highlights,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons
                        .navigate_next_rounded), 
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
