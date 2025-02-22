import 'dart:ui';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClear;

  const ChatAppBar({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Stack(
        children: [
          // Blurred background only inside the AppBar area
          Positioned.fill(
            child: ClipRect(
              // Ensures blur is constrained to AppBar
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10, sigmaY: 10), // Frosted glass effect
                child: Container(
                  color:
                      Colors.purpleAccent.withAlpha(20), // Adjust transparency
                ),
              ),
            ),
          ),
          AppBar(
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.transparent, // Solid background for title
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                "ATHENA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "nasa",
                  color: Colors.purpleAccent,
                  letterSpacing: 5,
                  fontSize: 30,
                  shadows: [Shadow(
                    color: Colors.purpleAccent,
                    offset: Offset(0, 0),
                    blurRadius: 5.0,
                  )],
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Ensure background is transparent
            elevation: 0,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.replay_rounded, color: Colors.grey),
                  onPressed: onClear,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
