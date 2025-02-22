// lib/card/movies_timing.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Data model for a single show timing.
class ShowTiming {
  final String time;
  final String special;
  final String format;

  const ShowTiming({
    required this.time,
    required this.special,
    required this.format,
  });
}

/// A card widget that displays the timings for a cinema (theater).
///
/// The card shows the theater name and a horizontal list of available show timings.
/// When a timing is tapped, a dialog appears with its details.
class MoviesTimingCard extends StatelessWidget {
  final String theater;
  final List<ShowTiming> shows;

  const MoviesTimingCard({
    super.key,
    required this.theater,
    required this.shows,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75, // Card takes 75% of the viewport width
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts height to fit content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the theater (cinema) name.
              Text(
                theater,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Horizontal scrollable row of show timings with auto height.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: shows.map((show) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            // Debug print the selected timing details.
                            debugPrint(
                              "Selected timing: Theater: $theater, Time: ${show.time}, Special: ${show.special}, Format: ${show.format}",
                            );
                            // Show a dialog with the timing details.
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Show Details"),
                                  content: Text(
                                    "Theater: $theater\n"
                                    "Time: ${show.time}\n"
                                    "Special: ${show.special}\n"
                                    "Format: ${show.format}",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.white70),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  show.time,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  show.special,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  show.format,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(),
    );
  }
}

/// Example data generator for MoviesTimingCard widgets using the new data format.
List<MoviesTimingCard> getMoviesTimingCards(List<Map<String, String>> response) {
  final List<Map<String, dynamic>> cinemasDataList = response;

  return cinemasDataList.map((response) {
    List<ShowTiming> shows = (response["shows"] as List).map((item) {
      return ShowTiming(
        time: item["time"],
        special: item["special"],
        format: item["format"],
      );
    }).toList();

    return MoviesTimingCard(
      theater: response["theater"],
      shows: shows,
    );
  }).toList();
}

/// Utility function that, given a cinema (theater) name, prints all its available timings.
///
/// This function looks up the cinema in the static data and prints the details
/// (time, special, format) to the debug console.
/// 
/// COMMENTED BY DEEPANSHU IDK use of it so check if not working
/// 
// void printTimingsForCinema(String cinemaName) {
//   final cards = getMoviesTimingCards();
//   try {
//     final card = cards.firstWhere((card) => card.theater == cinemaName);
//     String timingsMessage = "Available timings for $cinemaName:\n";
//     for (var show in card.shows) {
//       timingsMessage +=
//           "Time: ${show.time}, Special: ${show.special}, Format: ${show.format}\n";
//     }
//     debugPrint(timingsMessage);
//   } catch (e) {
//     debugPrint("Cinema not found: $cinemaName");
//   }
// }

