import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/Buttom_with_icom.dart';
import 'package:instagram_clone/screens/add_pollution_point_screen.dart';

void MyShowBottomSheet(BuildContext context) {
  GoToAddPostScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddScreenPollutionPoint();
    }));
  }

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(25.0),
    )),
    backgroundColor: secondaryColor,
    builder: (BuildContext context) {
      return const SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
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
              ButtonWithIcon2(
                icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                text: "add a poin",
              ),
              ButtonWithIcon(
                  icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                  text: "add a poin",
                  onPressed: null),
              ButtonWithIcon(
                  icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                  text: "add a poin",
                  onPressed: null),
              ButtonWithIcon(
                  icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                  text: "add a poin",
                  onPressed: null),
            ]),
      );
    },
  );
}
