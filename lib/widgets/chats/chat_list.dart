import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../messages/message_bubble.dart';

/// A pulsing circle widget that continuously scales between 1.0 and 1.4.
class PulsingCircle extends StatefulWidget {
  const PulsingCircle({Key? key}) : super(key: key);

  @override
  _PulsingCircleState createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with a duration of 600ms.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create an animation that scales from 1.0 (normal) to 1.4 (pulsed).
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    // Start the animation.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: child,
            );
          },
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

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
            bubble = const PulsingCircle();
            break;

          default:
            bubble = msg["data"];
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
