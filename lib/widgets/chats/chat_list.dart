import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../messages/message_bubble.dart';

/// A pulsing circle widget that continuously scales between 1.0 and 1.4.
class PulsingCircle extends StatefulWidget {
  const PulsingCircle({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PulsingCircleState createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
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

class ThinkingText extends StatefulWidget {
  const ThinkingText({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ThinkingTextState createState() => _ThinkingTextState();
}

class _ThinkingTextState extends State<ThinkingText> {
  int dotCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 6;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hmm${"." * dotCount}",
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
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

  Widget _pillButton(IconData icon, MaterialAccentColor avatarColor, String text) {
    return Chip(
      avatar: Icon(icon, color: avatarColor, size: 18),
      label: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return messages.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centers vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centers horizontally
              children: [
                Text(
                  "How May I Help You?",
                  textAlign: TextAlign.center, // Centers text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent[50],
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center, // Ensures pills are centered
                  spacing: 8.0,
                  children: [
                    _pillButton(Icons.shopping_bag, Colors.blueAccent, "Shopping"),
                    _pillButton(Icons.movie_filter_rounded, Colors.redAccent, "Movies"),
                    _pillButton(Icons.restaurant, Colors.orangeAccent, "Restaurant"),
                    _pillButton(Icons.hotel, Colors.greenAccent, "Travel & Stay"),
                    _pillButton(Icons.newspaper, Colors.deepPurpleAccent, "News"),
                  ],
                ),
              ],
            ),
          )
        : ListView.builder(
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
                          topLeft: isUser ? Radius.circular(10) : Radius.zero,
                          topRight: isUser ? Radius.zero : Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
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
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                          // a: const TextStyle(
                          //     color: Colors.blue,
                          //     decoration: TextDecoration.underline),
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
                        topLeft: isUser ? Radius.circular(10) : Radius.zero,
                        topRight: isUser ? Radius.zero : Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child:
                          Image.file(File(msg["imagePath"]), fit: BoxFit.cover),
                    ),
                  );
                  break;

                case "loading":
                  bubble = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      PulsingCircle(),
                      SizedBox(width: 4),
                      ThinkingText(),
                    ],
                  );
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
