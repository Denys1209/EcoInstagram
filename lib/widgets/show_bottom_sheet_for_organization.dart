import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_pollution_point_screen.dart';
import 'package:instagram_clone/screens/create_post_screen.dart';
import 'package:instagram_clone/screens/map_get_point.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/buttom_with_icon.dart';

void showBottomSheetForOrganization(BuildContext context) {
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(25.0),
    )),
    backgroundColor: secondaryColor,
    builder: (BuildContext context) {
      return SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Text("create",
                        style: TextStyle(color: primaryColor, fontSize: 20)),
                  ],
                ),
              ),
              ButtonWithIcon(
                  icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                  text: "craete a pollution report",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddScreenPollutionPoint()));
                  }),
              ButtonWithIcon(
                  icon: IconData(0xf643, fontFamily: 'MaterialIcons'),
                  text: "create a clean event",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScreenGetPointOnMap()));
                  }),
              ButtonWithIcon(
                  icon: IconData(0xe122, fontFamily: 'MaterialIcons'),
                  text: "create an event",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScreenGetPointOnMap(
                              goToAlocateScreen: false,
                            )));
                  }),
              ButtonWithIcon(
                  icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                  text: "craete a post",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CreatePostScreen()));
                  }),
            ]),
      );
    },
  );
}