import 'package:flutter/material.dart';

class SnackBarUtil {
  void message({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
