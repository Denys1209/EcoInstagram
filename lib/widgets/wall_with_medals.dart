import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;

class WallWithMedals extends StatefulWidget {
  final model.User user;
  const WallWithMedals({super.key, required this.user});

  @override
  State<WallWithMedals> createState() => _WallWithMedalsState();
}

class _WallWithMedalsState extends State<WallWithMedals> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        shrinkWrap: true,
        physics:
            ScrollPhysics(), // Enable scrolling within the SingleChildScrollView
        crossAxisCount: 3,
        children: List.generate(
          100,
          (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          },
        ),
      ),
    );
  }
}
