import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;

class Medal extends StatelessWidget {
  
  model.User user;
  Medal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      color: Colors.orange,
      child: const Stack(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            backgroundColor: Colors.transparent,
          ),
          Positioned.fill(
            child: CircularProgressIndicator(
              value: 0.5, // Set the value to 0.5 for 50% fill
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors
                  .red), // Change the color to your desired indicator color
            ),
          ),
        ],
      ),
    );
  }
}
