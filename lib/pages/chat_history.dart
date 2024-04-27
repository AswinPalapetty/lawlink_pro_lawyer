import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/chat_history_card.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  bool isLoading = true;
  late Map<String, String> user;
  late List<Map<String, dynamic>> clients = [];
  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  fetchChats() async {
    user = await SessionManagement.getUserData();
    print(user['userId']);
    final result = await Supabase.instance.client
        .from('message')
        .select('user_from')
        .eq('user_to', user['userId']!);
    Set<String> uniqueUserFrom = <String>{};
    if (result.isNotEmpty) {
      for (var clientId in result) {
        uniqueUserFrom
            .add(clientId['user_from']); // Add user_from value to the Set
      }
      for (var userFrom in uniqueUserFrom) {
        //print(clientId);
        final client = await Supabase.instance.client
            .from('clients')
            .select()
            .eq('user_id', userFrom)
            .single();
        clients.add(client);
      }
    }
    print(clients);
    // List<String> userIds = List<String>.from(result[0]['lawyers']);
    // for (var userId in userIds) {
    //   final lawyer = await Supabase.instance.client.from('lawyers').select().eq('user_id', userId).single();
    //   lawyer['practice_areas'] = lawyer['practice_areas'].join(',');
    //   print(lawyer);
    //   favoriteLawyers.add(lawyer);
    // }
    setState(() {
      isLoading = false;
    });
  }

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
        body: isLoading
            ? const CustomProgressIndicator()
            : clients.isNotEmpty
                ? ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final data = clients[index];
                      return ChatHistoryCard(
                        latestMessage: '',
                        latestMessageTime: '',
                        name: data['name'] ??
                            '', // Replace 'name' with the actual field name
                        onTap: () {
                          Navigator.pushNamed(context, '/chat_page',
                              arguments: {
                                'clientId': data['user_id'],
                                'clientName': data['name']
                              });
                        },
                      );
                    },
                  )
                : const Center(child: Text("No chats found")));
  }
}
