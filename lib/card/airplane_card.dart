// lib/airplane_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AirplaneCard extends StatelessWidget {
  final String airline;
  final String airlineLogo;
  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;
  final String duration;
  final String price;
  final String fareType;
  final String offer;
  final String layover;
  final String url;

  const AirplaneCard({
    super.key,
    required this.airline,
    required this.airlineLogo,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.duration,
    required this.price,
    required this.fareType,
    required this.offer,
    required this.layover,
    required this.url,
  });

  Future<void> _launchUrl() async {
    if (url.isEmpty) return;
    
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: url.isNotEmpty
          ? () {
              showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text("Confirmation"),
                    content: const Text(
                        "Do you want to proceed to the airline website?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text("Back"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text("Ok"),
                      ),
                    ],
                  );
                },
              ).then((confirmed) {
                if (confirmed == true) _launchUrl();
              });
            }
          : null,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airline header
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Image.network(
                      airlineLogo,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.airplanemode_active, size: 40),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airline,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        fareType,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Flight route
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureCity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        departureTime,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.flight_takeoff, color: Colors.white),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalCity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Flight details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration.replaceAll('—', '').trim(),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: layover == "0" ? Colors.green[800] : Colors.red[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      layover == "0" ? "Nonstop" : "$layover Stop${layover != "1" ? "s" : ""}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price and offer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (offer.isNotEmpty)
                    Flexible(
                      child: Text(
                        offer,
                        style: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(),
    );
  }
}

List<AirplaneCard> getAirplaneCards(List<Map<String, String>> response) {
  return response.map((flight) {
    return AirplaneCard(
      airline: flight["airline"] ?? "",
      airlineLogo: flight["airline_logo"] ?? "",
      departureTime: flight["departure_time"] ?? "",
      departureCity: flight["departure_city"] ?? "",
      arrivalTime: flight["arrival_time"] ?? "",
      arrivalCity: flight["arrival_city"] ?? "",
      duration: flight["duration"] ?? "",
      price: flight["price"] ?? "",
      fareType: flight["fare_type"] ?? "",
      offer: flight["offer"] ?? "",
      layover: flight["layover"] ?? "0",
      url: flight["url"] ?? "",
    );
  }).toList();
}