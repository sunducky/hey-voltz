import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Toasty {
  BuildContext context;
  Toasty(this.context);

  showToastMessage({required String message, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.announcement,
            color: Colors.white,
          ),
          const SizedBox(width: 15),
          Text(
            message,
          )
        ],
      ),
      dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      duration: (duration != null) ? duration : const Duration(seconds: 2),
    ));
  }

  showToastErrorMessage({required String message, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 15),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.red,
      dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      duration: (duration != null) ? duration : const Duration(seconds: 2),
    ));
  }

  showToastSuccessMessage({required String message, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.beenhere,
            color: Colors.white,
          ),
          const SizedBox(width: 15),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.green,
      dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      duration: (duration != null) ? duration : const Duration(seconds: 2),
    ));
  }
}
