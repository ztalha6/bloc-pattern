import 'package:bloc_pattren_sample/dialog/genaric_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showDeleteAccountDialog(BuildContext context) async {
  return await showGenericDialog<bool>(
        context: context,
        title: 'Delete Account',
        content: 'Are you sure you want to delete the account?',
        optionBuilder: () => {
          'Cancel': false,
          'Delete Account': true,
        },
      ) ??
      false;
}
