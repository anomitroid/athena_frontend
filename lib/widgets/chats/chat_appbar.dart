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
                      Colors.purpleAccent.withAlpha(5), // Adjust transparency
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
                  shadows: [
                    Shadow(
                      color: Colors.purple,
                      offset: Offset(0, 0),
                      blurRadius: 50.0,
                    )
                  ],
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.transparent, // Ensure background is transparent
            elevation: 0,
            leading: IconButton(
              // temp onpressed function
              onPressed: onClear,
              icon: const Icon(Icons.menu_rounded),
              color: Colors.white,
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.add_comment_rounded,
                      color: Colors.white),
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
