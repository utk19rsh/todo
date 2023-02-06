import 'package:flutter/material.dart';
import 'package:todo/components/constants/constants.dart';

class MySnackBar {
  final BuildContext context;
  MySnackBar(this.context);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> build(
    String snackMsg,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMsg),
        backgroundColor: black,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(milliseconds: 1500),
        elevation: 1,
        padding: const EdgeInsets.fromLTRB(30, 15, 10, 15),
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
