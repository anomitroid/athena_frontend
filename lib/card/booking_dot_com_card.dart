// lib/card/booking_card_dot_com.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingCard extends StatelessWidget {
  final String _imageUrl;
  final String _hotelUrl;
  final String _title;
  final String _rating;
  final String _reviewCount;
  final String _reviewComment;
  final String _price;
  final String _breakfastIncluded;

  const BookingCard({
    super.key,
    required String imageUrl,
    required String hotelUrl,
    required String title,
    required String rating,
    required String reviewCount,
    required String reviewComment,
    required String price,
    required String breakfastIncluded,
  })  : _imageUrl = imageUrl,
        _hotelUrl = hotelUrl,
        _title = title,
        _rating = rating,
        _reviewCount = reviewCount,
        _reviewComment = reviewComment,
        _price = price,
        _breakfastIncluded = breakfastIncluded;

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(_hotelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $_hotelUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "Do you want to proceed to the Booking.com listing?"),
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
        ).then((confirmed) {
          if (confirmed == true) {
            _launchUrl();
          }
        });
      },
      child: FractionallySizedBox(
        widthFactor: 0.75, // 3/4 of the viewport width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(16)),
                child: Image.network(
                  _imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  _reviewComment,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Icon(
                      _breakfastIncluded == "True"
                          ? Icons.restaurant
                          : Icons.no_meals,
                      color: _breakfastIncluded == "True"
                          ? Colors.green
                          : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _breakfastIncluded == "True"
                          ? "Breakfast Included"
                          : "No Breakfast",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _breakfastIncluded == "True"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$_rating ($_reviewCount)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹$_price',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ).animate().fade(duration: 300.ms).slideX(),
      ),
    );
  }
}

List<BookingCard> getBookingCards(dynamic response) {
  final List<Map<String, dynamic>> scrapedDataList = response;

  return scrapedDataList.map((data) {
    return BookingCard(
      imageUrl: data["image_url"],
      hotelUrl: data["hotel url"],
      title: data["title"],
      reviewComment: data["review comment"],
      rating: data["rating"],
      reviewCount: data["review count"],
      price: data["price"],
      breakfastIncluded: data["Breakfast included"] ?? "False",
    );
  }).toList();
}
