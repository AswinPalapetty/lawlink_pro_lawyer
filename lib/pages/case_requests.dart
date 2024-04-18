import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/case_request_card.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';

class CaseRequests extends StatefulWidget {
  const CaseRequests({super.key});

  @override
  State<CaseRequests> createState() => _CaseRequestsState();
}

class _CaseRequestsState extends State<CaseRequests> {
  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
      child: ListView(
        children: const [ 
          CaseRequestCard(
          clientName: 'John Doe',
          subject: "case request",
          matter: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
        ]
      ),
    );
  }
}