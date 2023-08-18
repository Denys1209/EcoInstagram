import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/buttom_with_icom.dart';

void MyShowBottomSheet(BuildContext context) {
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
              ButtonWithIcon3(
                icon: IconData(0xf643, fontFamily: 'MaterialIcons'),
                text: "add a cleaner event",
              ),
              ButtonWithIcon4(
                  icon: IconData(0xe122, fontFamily: 'MaterialIcons'),
                  text: "add an event",
                  ),
              ButtonWithIcon(
                  icon: IconData(0xe752, fontFamily: 'MaterialIcons'),
                  text: "add a poin",
                  onPressed: null),
            ]),
      );
    },
  );
}
