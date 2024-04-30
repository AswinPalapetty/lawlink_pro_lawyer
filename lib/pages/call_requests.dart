import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/call_request_card.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CallRequests extends StatefulWidget {
  const CallRequests({super.key});

  @override
  State<CallRequests> createState() => _CallRequestsState();
}

class _CallRequestsState extends State<CallRequests> {
  late PostgrestList callRequests;
  late String userId;
  bool isLoading = true;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchCallRequests();
    });
  }

  void fetchCallRequests() async {
    isLoading = true;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      userId = args['userId'];
    });
    callRequests = await Supabase.instance.client
        .from('call_booking')
        .select()
        .eq('lawyer_id', userId)
        .eq('accepted', false)
        .eq('rejected', false)
        .order('created_at');
    print(callRequests);
    setState(() {
      isLoading = false;
    });
  }

  Future<Map<String, dynamic>> fetchClient(String clientId) async {
    final response = await Supabase.instance.client
        .from('clients')
        .select('name')
        .eq('user_id', clientId)
        .single();
    return response;
  }

  void onAcceptpressed(int caseRequestId, String clientId) async {
    await Supabase.instance.client
        .from('call_booking')
        .update({'accepted': true}).eq('id', caseRequestId);
    final snackBar = SnackBar(
        content: const Text('Call request accepted. Client will call you in specified time period.'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    fetchCallRequests();
  }

  void onRejectpressed(int caseRequestId) async {
    await Supabase.instance.client
        .from('call_booking')
        .update({'rejected': true}).eq('id', caseRequestId);
    final snackBar = SnackBar(
        content: const Text('Call request rejected.'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    fetchCallRequests();
  }

  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
      child: isLoading
          ? const CustomProgressIndicator()
          : callRequests.isNotEmpty
              ? ListView.builder(
                  itemCount: callRequests.length,
                  itemBuilder: (context, index) {
                    final caseRequest = callRequests[index];
                    return FutureBuilder(
                      future: fetchClient(caseRequest['client_id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final client = snapshot.data;
                          return CallRequestCard(
                            clientName: client?['name'],
                            dateTime: '${caseRequest['date']} ${caseRequest['time_slot']}',
                            matter: caseRequest['description'],
                            hours: int.parse(caseRequest['hours']),
                            onAcceptpressed: () => onAcceptpressed(
                                caseRequest['id'], caseRequest['client_id']),
                            onRejectpressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Reject Case'),
                                    content: const Text(
                                        'Are you sure you want to reject this case?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(), // Close the dialog
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Close the dialog and execute the reject function
                                          Navigator.of(context).pop();
                                          onRejectpressed(caseRequest['id']);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                )
              : const Center(
                  child: Text("No requests found."),
                ),
      // ListView(
      //   children: const [ 
      //     CallRequestCard(
      //     clientName: 'John Doe',
      //     dateTime: 'March 28, 2024, 10:00 AM',
      //     hours: 1,
      //     matter: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      //   ),
      //   ]
      // ),
    );
  }
}