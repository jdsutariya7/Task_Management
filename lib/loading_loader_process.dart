import 'package:flutter/material.dart';

void showLoadingDialog(context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => WillPopScope(
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
      onWillPop: () async {
        return false;
      },
    ),
  );
}


void hideLoadingDialog(context){
  Navigator.pop(context);
}
