import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/case_request_card.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CaseRequests extends StatefulWidget {
  const CaseRequests({super.key});

  @override
  State<CaseRequests> createState() => _CaseRequestsState();
}

class _CaseRequestsState extends State<CaseRequests> {
  late PostgrestList caseRequests;
  late String userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchCaseRequests();
    });
  }

  void fetchCaseRequests() async {
    isLoading = true;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      userId = args['userId'];
    });
    caseRequests = await Supabase.instance.client
        .from('lawyer_booking')
        .select()
        .eq('lawyer_id', userId)
        .eq('accepted', false)
        .eq('rejected', false)
        .order('created_at');
    print(caseRequests);
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
        .from('lawyer_booking')
        .update({'accepted': true}).eq('id', caseRequestId);
    await Supabase.instance.client.from('case_proceedings').insert({
      'request_id': caseRequestId.toString(),
      'client_id': clientId,
      'lawyer_id': userId
    });
    final snackBar = SnackBar(
        content: const Text('Case accepted.'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    fetchCaseRequests();
  }

  void onRejectpressed(int caseRequestId) async {
    await Supabase.instance.client
        .from('lawyer_booking')
        .update({'rejected': true}).eq('id', caseRequestId);
    final snackBar = SnackBar(
        content: const Text('Case rejected.'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    fetchCaseRequests();
  }

  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
      child: isLoading
          ? const CustomProgressIndicator()
          : caseRequests.isNotEmpty
              ? ListView.builder(
                  itemCount: caseRequests.length,
                  itemBuilder: (context, index) {
                    final caseRequest = caseRequests[index];
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
                          return CaseRequestCard(
                            clientName: client?['name'],
                            subject: caseRequest['subject'],
                            matter: caseRequest['description'],
                            onAcceptpressed: () => onAcceptpressed(
                                caseRequest['id'], caseRequest['client_id']),
                            onRejectpressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Reject Case'),
                                    content: Text(
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
    );
  }
}
