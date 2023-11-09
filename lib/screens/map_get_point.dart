import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:instagram_clone/screens/alocate_map.dart';
import 'package:instagram_clone/screens/create_event_screen.dart';
import 'package:latlong2/latlong.dart';

class ScreenGetPointOnMap extends StatefulWidget {
  final bool goToAlocateScreen;
  const ScreenGetPointOnMap({
    super.key,
    this.goToAlocateScreen = true,
  });

  @override
  State<ScreenGetPointOnMap> createState() => _ScreenGetPointOnState();
}

class _ScreenGetPointOnState extends State<ScreenGetPointOnMap> {
  LatLng? _touchedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Stack(
          fit: StackFit.expand,
          children: [
            FlutterMap(
              options: MapOptions(
                zoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _touchedPoint = point;
                  });
                },
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  maxZoom: 22,
                  userAgentPackageName: 'com.example.instagram_clone',
                ),
                MarkerLayer(
                  markers: _touchedPoint == null
                      ? []
                      : [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _touchedPoint!,
                            builder: (ctx) => const SizedBox(
                              width: 30,
                              height: 50,
                              child: Icon(
                                Icons.flag,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                ),
                _touchedPoint != null
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (widget.goToAlocateScreen) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlocateMap(
                                      point: _touchedPoint!,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateEventScreen(
                                      point: _touchedPoint!,
                                    ),
                                  ),
                                );
 
                              }
                            },
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.place),
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          ],
        ));
  }
}
