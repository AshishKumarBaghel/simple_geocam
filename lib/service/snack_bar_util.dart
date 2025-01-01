import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackBarUtil {
  void message({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void messageTop({required BuildContext context, required String message}) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 1),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
