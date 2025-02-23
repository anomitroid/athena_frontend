import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onCancel;
  final VoidCallback onImagePick;

  const ChatInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSend,
    required this.onCancel,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // TextField container wrapped in a Stack to overlay the clip icon.
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isLoading ? Colors.grey : Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // Enforce a minimum height to match the send button while allowing growth.
              constraints: const BoxConstraints(
                minHeight: 56,
                maxHeight: 150, // Adjust maximum height as needed.
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: !isLoading,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(24, 16, 48, 16),
                    ),
                  ),
                  // Clip icon always at the bottom right of the text box.
                  Positioned(
                    right: 8,
                    bottom: 4,
                    child: IconButton(
                      icon: const Icon(
                        Icons.attach_file_rounded,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: onImagePick,
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send/Cancel button.
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: isLoading ? Colors.redAccent : Colors.purpleAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              onPressed: isLoading ? onCancel : onSend,
              icon: Icon(
                isLoading ? Icons.stop : Icons.send_rounded,
                color: Colors.white,
                size: 32,
              ),
              splashRadius: 28,
            ),
          ),
        ],
      ),
    );
  }
}
