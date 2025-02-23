// lib/card/movies_timing.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviesTimingCard extends StatelessWidget {
  final String theater;
  final String time;
  final String special;
  final String format;
  final String url;

  const MoviesTimingCard({
    super.key,
    required this.theater,
    required this.time,
    required this.special,
    required this.format,
    required this.url,
  });

  Future<void> _launchUrl() async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.75,
        child: Animate(
          effects: [
            FadeEffect(duration: 300.ms),
            SlideEffect(
                begin: Offset(-1, 0), end: Offset(0, 0), duration: 300.ms)
          ],
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(16)),
            ),
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theater name
                  Text(
                    theater,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Movie details
                  _buildInfoRow("Format", format),
                  _buildInfoRow("Special", special),
                  const SizedBox(height: 12),

                  // Time and booking
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Timing: $time",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (url.isNotEmpty)
                        GestureDetector(
                          onTap: _launchUrl,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

List<MoviesTimingCard> getMoviesTimingCards(
    List<Map<String, String>> response) {
  return response.map((showData) {
    return MoviesTimingCard(
      theater: showData["theater"] ?? "Unknown Theater",
      time: showData["time"] ?? "--:--",
      special: showData["special"] ?? "Standard",
      format: showData["format"] ?? "2D",
      url: showData["url"] ?? "",
    );
  }).toList();
}
