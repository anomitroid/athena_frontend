import 'package:flutter/material.dart';

Widget buildMessageWithIcon({
  required Widget messageWidget,
  required int index,
  required List<Map<String, dynamic>> messages,
  required bool isUser,
}) {
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: messageWidget,
  );
}
