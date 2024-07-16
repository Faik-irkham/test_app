import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:test_app/shared/theme.dart';

void showCustomSnackbar(BuildContext context, String message) {
  Flushbar(
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: redColor,
    duration: const Duration(seconds: 30),
  ).show(context);
}
