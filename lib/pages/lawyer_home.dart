import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';
import 'package:lawlink_lawyer/widgets/option_card.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:lawlink_lawyer/widgets/time_slot_modal.dart';

class LawyerHome extends StatefulWidget {
  const LawyerHome({super.key});

  @override
  State<LawyerHome> createState() => _LawyerHomeState();
}

class _LawyerHomeState extends State<LawyerHome> {
  late Map<String, String> user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    final sessionData = await SessionManagement.getUserData();
    setState(() {
      user = sessionData;
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
        child: isLoading
            ? const CustomProgressIndicator()
            : ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8, right: 8),
          child: OptionCard(
            icon: Icons.phone_callback,
            optionHeading: 'Call Requests',
            onTap: () {
              Navigator.pushNamed(context, '/call_requests', arguments: { 'userId': user['userId'] });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8, right: 8),
          child: OptionCard(
            icon: Icons.cases_rounded,
            optionHeading: 'Case requests',
            onTap: () {
              Navigator.pushNamed(context, '/case_requests', arguments: { 'userId': user['userId'] });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8, right: 8),
          child: OptionCard(
            icon: Icons.settings,
            optionHeading: 'Call Settings',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return TimeSlotModal(lawyerId: user['userId']!,); // Use the TimeSlotModal widget
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8, right: 8),
          child: OptionCard(
            icon: Icons.account_circle_rounded,
            optionHeading: 'Manage Profile',
            onTap: () {
              Navigator.pushNamed(context, '/update_profile');
            },
          ),
        ),
      ],
    ));
  }
}
