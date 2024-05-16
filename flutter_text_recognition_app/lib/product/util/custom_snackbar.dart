import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context,
      {required String message, required Color backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
