import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/chat_history_card.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chats',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
        children: [
          ChatHistoryCard(
            name: 'John Doe',
            latestMessage: 'Hi there!',
            latestMessageTime: '10:30 AM',
            imageUrl: 'https://ehygpasjbxqmlqqmomhg.supabase.co/storage/v1/object/public/lawyer_profile//3a99eeb3-d72f-4730-9027-86954641b0b5/profile?t=1713194928594',
            onTap: () => {
              Navigator.pushNamed(context, '/chat_page', arguments: {
                    'clientId': '0d155888-2cec-4b49-80bd-dd52c5a1888e',
                    'clientName': 'Aswin P'
                  })
            }
          ),
          ChatHistoryCard(
            name: 'Jane Smith',
            latestMessage: 'How are you?',
            latestMessageTime: 'Yesterday',
            imageUrl: 'https://ehygpasjbxqmlqqmomhg.supabase.co/storage/v1/object/public/lawyer_profile//3a99eeb3-d72f-4730-9027-86954641b0b5/profile?t=1713194928594',
            onTap: () => {
              Navigator.pushNamed(context, '/chat_page')
            },
          ),
        ],
      ),
    );
  }
}