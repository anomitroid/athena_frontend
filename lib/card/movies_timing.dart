// lib/card/movies_timing.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A card widget that displays movie timing information
class MoviesTimingCard extends StatelessWidget {
  final String theater;
  final String time;
  final String special;
  final String format;

  const MoviesTimingCard({
    super.key,
    required this.theater,
    required this.time,
    required this.special,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text("Show Details"),
                    content: Text(
                      "Theater: $theater\n"
                      "Time: $time\n"
                      "Special: $special\n"
                      "Format: $format",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
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
                ),
                const SizedBox(height: 12),
                // Timing information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Time", time),
                        _buildInfoRow("Special", special),
                        _buildInfoRow("Format", format),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Converts API response to list of MoviesTimingCards
List<MoviesTimingCard> getMoviesTimingCards(List<Map<String, String>> response) {
  return response.map((showData) {
    return MoviesTimingCard(
      theater: showData["theatre"] ?? "Unknown Theater",
      time: showData["time"] ?? "--:--",
      special: showData["special"] ?? "Standard",
      format: showData["format"] ?? "2D",
    );
  }).toList();
}