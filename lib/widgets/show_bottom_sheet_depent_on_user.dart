import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/widgets/show_bottom_sheet_for_organization.dart';
import 'package:instagram_clone/widgets/show_bottom_sheet_for_user.dart';

import 'package:provider/provider.dart';
import '../models/user.dart';

void showBottomSheetDependOnUser(BuildContext context) {
  final User user = Provider.of<UserProvider>(context, listen: false).getUser;
  if (user.isOrganization) {
    showBottomSheetForOrganization(context);
  } else {
    showBottomSheetForUser(context);
  }
}
