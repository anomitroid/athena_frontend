import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../messages/message_bubble.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final ScrollController scrollController;
  final double maxBubbleWidth;

  const ChatList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.maxBubbleWidth,
  });

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;

    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch URL: $url");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final String sender = msg["sender"] ?? "bot";
        final bool isUser = sender == "user";

        Widget bubble;
        switch (msg["type"]) {
          case "text":
            bubble = ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isUser ? Colors.purpleAccent : Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: isUser ? Radius.circular(16) : Radius.zero,
                    topRight: isUser ? Radius.zero : Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: MarkdownBody(
                  data: msg["text"].toString(),
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.white),
                    h1: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    blockquote: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                    ),
                    strong: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                    a: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  onTapLink: (text, url, title) {
                    if (url != null) _launchURL(url);
                  },
                ),
              ),
            ).animate().fade(duration: 300.ms).slideX(
                  begin: isUser ? 1 : -1,
                );
            break;

          case "image":
            bubble = ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxBubbleWidth,
                maxHeight: 250,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? Radius.circular(16) : Radius.zero,
                  topRight: isUser ? Radius.zero : Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Image.file(File(msg["imagePath"]), fit: BoxFit.cover),
              ),
            );
            break;

          case "loading":
            bubble = SizedBox(
              height: 48,
              width: 48,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ).animate().fade(duration: 300.ms).slideX(
                  begin: isUser ? 1 : -1,
                );
            break;

          default:
            bubble = ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isUser ? Colors.purpleAccent : Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: msg["data"] ??
                    const Text(
                      "Unsupported message type",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
              ),
            );
            break;
        }

        return buildMessageWithIcon(
          messageWidget: bubble,
          index: index,
          messages: messages,
          isUser: isUser,
        );
      },
    );
  }
}
