import 'package:bloc_pattren_sample/dialog/genaric_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showGenericDialog<bool>(
        context: context,
        title: 'Log out',
        content: 'Are you sure you want to logout?',
        optionBuilder: () => {
          'Cancel': false,
          'Logout': true,
        },
      ) ??
      false;
}
