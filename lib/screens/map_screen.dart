import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:instagram_clone/screens/pollution_point_screen.dart';
import 'package:instagram_clone/widgets/my_mark.dart';
import 'package:latlong2/latlong.dart';

import '../utils/utils.dart';

class mapScreen extends StatefulWidget {
  const mapScreen({super.key});

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pollutionPoints');

  List<Marker> marks = List.empty();
  bool loadEnd = false;

  getMarks() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Marker> marksList = List.empty(growable: true);
    for (var i in allData) {
      var snap = i as Map<String, dynamic>;
      marksList.add(
        Marker(
            point: LatLng(snap["LAT"] as double, snap["LNG"] as double),
            builder: (context) {
              return my_mark(snap: snap);
            },
            width: 30,
            height: 30),
      );
    }
    setState(() {
      marks = marksList;
      loadEnd = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    getMarks();
    return loadEnd
        ? FlutterMap(
            options: MapOptions(
              center: LatLng(37, -122),
              zoom: 0,
              maxZoom: 22,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=cd99f5c7c17f4283b28ee777c33ebc7a',
                subdomains: ['a', 'b', 'c'],
                maxZoom: 22,
                userAgentPackageName: 'com.example.instagram_clone',
              ),
              MarkerLayer(markers: marks)
            ],
          )
        : Scaffold(body: Center(child: Center(child: Text("Loading"))));
  }
}
