import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

///Local Notifications Handler
class LocalNotif {
  ///Show Notification with `message`
  static void show({
    required String title,
    required String message,
  }) {
    toastification.show(
      title: Text(title),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
