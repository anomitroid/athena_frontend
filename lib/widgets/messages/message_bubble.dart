import 'package:flutter/material.dart';

Widget buildMessageWithIcon({
  required Widget messageWidget,
  required int index,
  required List<Map<String, dynamic>> messages,
  required bool isUser,
}) {
  bool showIcon = true;
  if (index > 0) {
    final prevMsg = messages[index - 1];
    if (prevMsg["sender"] == messages[index]["sender"]) {
      showIcon = false;
    }
  }

  const double iconPadding = 4.0;
  const double iconSizeValue = 30.0;
  // Calculate overall icon height (icon + vertical padding)
  const double overallIconHeight = iconSizeValue + (iconPadding * 2);

  Widget iconWidget = Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isUser ? Colors.purpleAccent : Colors.grey[800],
    ),
    padding: const EdgeInsets.all(iconPadding),
    child: Icon(
      isUser ? Icons.person_rounded : Icons.smart_toy_rounded,
      size: iconSizeValue,
      color: Colors.white,
    ),
  );

  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Push the message down by the icon's height so the icon sits above it.
        Container(
          margin: showIcon
              ? const EdgeInsets.only(top: overallIconHeight)
              : EdgeInsets.zero,
          child: messageWidget,
        ),
        if (showIcon)
          Positioned(
            top: 0,
            // For bot messages, align icon to the left; for user messages, to the right.
            left: isUser ? null : 0,
            right: isUser ? 0 : null,
            child: iconWidget,
          ),
      ],
    ),
  );
}
