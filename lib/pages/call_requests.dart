import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/call_request_card.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';

class CallRequests extends StatefulWidget {
  const CallRequests({super.key});

  @override
  State<CallRequests> createState() => _CallRequestsState();
}

class _CallRequestsState extends State<CallRequests> {
  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
      child: ListView(
        children: const [ 
          CallRequestCard(
          clientName: 'John Doe',
          dateTime: 'March 28, 2024, 10:00 AM',
          hours: 1,
          matter: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
        ]
      ),
    );
  }
}