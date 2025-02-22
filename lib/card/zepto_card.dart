// lib/card/zepto_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class ZeptoCard extends StatelessWidget {
  final String url;
  final String img;
  final String name;
  final String? subtitle;
  final String price;

  const ZeptoCard({
    super.key,
    required this.url,
    required this.img,
    required this.name,
    this.subtitle,
    required this.price,
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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Open Product?"),
            content: const Text("Do you want to view this product on Zepto?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _launchUrl();
                },
                child: const Text("Open"),
              ),
            ],
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    img,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.shopping_bag),
                      ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      if (subtitle != null && subtitle!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                      // Price
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(),
    );
  }
}

// Helper function to create list of ZeptoCards
List<ZeptoCard> getZeptoCards(List<Map<String, dynamic>> response) {
  return response.map((product) {
    return ZeptoCard(
      url: product["url"]?.toString() ?? "",
      img: product["img"]?.toString() ?? "",
      name: product["name"]?.toString() ?? "Unnamed Product",
      subtitle: product["subtitle"]?.toString(),
      price: product["price"]?.toString() ?? "₹—",
    );
  }).toList();
}