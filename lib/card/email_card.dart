import 'package:flutter/material.dart';

class EmailCard extends StatelessWidget {
  final String emailSentTo;
  final String subject;
  final String body;

  const EmailCard({
    super.key,
    required this.emailSentTo,
    required this.subject,
    required this.body,
  });

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("Sent to", emailSentTo),
              Divider(thickness: 1, color: Colors.grey[700]),
              _buildSection("Subject", subject),
              Divider(thickness: 1, color: Colors.grey[700]),
              _buildSection("Body", body),
            ],
          ),
        ),
      ),
    );
  }
}

List<EmailCard> getEmailCards(dynamic response) {
  final List<Map<String, String>> emailDataList = response;

  return emailDataList.map((emailData) {
    return EmailCard(
      emailSentTo: emailData['email_sent_to'] ?? '',
      subject: emailData['subject'] ?? '',
      body: emailData['body'] ?? '',
    );
  }).toList();
}
