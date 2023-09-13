import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/event_card.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class EventsDisplayScreeen extends StatefulWidget {
  const EventsDisplayScreeen({super.key});

  @override
  State<EventsDisplayScreeen> createState() => _EventsDisplayScreeenState();
}

class _EventsDisplayScreeenState extends State<EventsDisplayScreeen> {
  List<String> _eventsTypes = List<String>.from(["Clean events", "Events"]);
  String _chooseType = "Clean events";
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: _chooseType,
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
              _chooseType = newValue!;
            });
          },
          items: _eventsTypes
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
      ),
      body: _chooseType == "Events" ? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('events')
            .where(FieldPath.documentId, whereIn: user.followingEvents)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => EventCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ) : FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('clean events')
            .where(FieldPath.documentId, whereIn: user.followingCleanEvents)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => EventCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}