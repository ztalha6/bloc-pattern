import 'package:bloc_pattren_sample/auth/auth_errors.dart';
import 'package:bloc_pattren_sample/dialog/genaric_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<void> showAuthErrorDialog({
  required AuthError authError,
  required BuildContext context,
}) async {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {'OK': true},
  );
}
