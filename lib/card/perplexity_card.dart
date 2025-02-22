import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PerplexityCard extends StatelessWidget {
  final String content;
  final List<String> sources;

  const PerplexityCard({
    super.key,
    required this.content,
    required this.sources,
  });

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return; // Prevent empty URLs from causing errors

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Prevent accidental taps from crashing the app
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          elevation: 6,
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPerplexityContent(),
                if (sources.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Divider(thickness: 1, color: Colors.grey[700]),
                  const SizedBox(height: 6),
                  _buildPerplexitySources(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerplexityContent() {
    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(fontSize: 16, color: Colors.white),
        h1: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        blockquote: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: Colors.grey[400],
        ),
        strong: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        a: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      ),
      onTapLink: (text, url, title) {
        if (url != null) {
          _launchURL(url);
        } else {
          debugPrint("Invalid URL: $url");
        }
      },
    );
  }

  Widget _buildPerplexitySources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sources:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          children: sources.map((url) => _buildPerplexitySourceItem(url)).toList(),
        ),
      ],
    );
  }

  Widget _buildPerplexitySourceItem(String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.link, size: 18, color: Colors.purple),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.purple,
                  // decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<PerplexityCard> getPerplexityCards(dynamic response) {
  final List<Map<String, String>> newsDataList = response;

  return newsDataList.map((newsData) {
    return PerplexityCard(
      content: newsData['response_content']!.replaceAll(RegExp(r'\[\d+\]'), ''),
      sources: List<String>.from(newsData['response_url']!.split(',')).where((url) => url.isNotEmpty).toList(),
    );
  }).toList();
}
