import 'package:flutter/material.dart';

class ChatHistoryCard extends StatelessWidget {
  final String name;
  final String latestMessage;
  final String latestMessageTime;
  final VoidCallback? onTap;

  const ChatHistoryCard({
    super.key,
    required this.name,
    required this.latestMessage,
    required this.latestMessageTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(latestMessage),
              trailing: Text(
                latestMessageTime,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}