import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviesListCard extends StatelessWidget {
  final String title;
  final String poster;
  final String ageRating;
  final String movieUrl;
  final String language;

  const MoviesListCard({
    super.key,
    required this.title,
    required this.poster,
    required this.ageRating,
    required this.movieUrl,
    required this.language,
  });

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(movieUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $movieUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text("Do you want to proceed to the movie page?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );

        if (confirmed == true) {
          _launchURL();
        }
      },
      child: FractionallySizedBox(
        widthFactor: 0.75, // 3/4 of the viewport width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AspectRatio(
                          aspectRatio:
                              2 / 3, // Default ratio (adjust if needed)
                          child: Image.network(
                            poster,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child:
                                    Icon(Icons.image_not_supported, size: 50),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft, // Moved rating to left
                      child: Text(
                        ageRating,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(80, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    language,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: 300.ms).slideX(),
        ),
      ),
    );
  }
}

List<MoviesListCard> getMoviesListCards(List<Map<String, String>> response) {
  final List<Map<String, dynamic>> moviesListDataList = response;

  return moviesListDataList.map((response) {
    return MoviesListCard(
      poster: response["poster"],
      movieUrl: response["link"],
      title: response["title"],
      language: response["language"],
      ageRating: response["age_rating"],
    );
  }).toList();
}

