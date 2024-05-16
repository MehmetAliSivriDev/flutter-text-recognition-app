import 'package:flutter/material.dart';

class ProductBoxDecorations {
  static var addWarningDecoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 3,
            spreadRadius: 2,
            offset: const Offset(0, 3))
      ],
      borderRadius: BorderRadius.circular(15),
      border:
          Border.all(color: Colors.black, width: 1, style: BorderStyle.solid));
}
