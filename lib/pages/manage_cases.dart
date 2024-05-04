import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';
import 'package:lawlink_lawyer/widgets/open_cases_card.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageCases extends StatefulWidget {
  const ManageCases({super.key});

  @override
  State<ManageCases> createState() => _ManageCasesState();
}

class _ManageCasesState extends State<ManageCases> {
  bool isLoading = true;
  late PostgrestList openCases;
  late Map<String, String> userData;

  @override
  void initState() {
    fetchAcceptedCases();
    super.initState();
  }

  void fetchAcceptedCases() async {
    userData = await SessionManagement.getUserData();
    openCases = await Supabase.instance.client
        .from('lawyer_booking')
        .select()
        .eq('lawyer_id', userData['userId']!)
        .eq('accepted', true)
        .order('created_at');
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

  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
      child: isLoading
          ? const CustomProgressIndicator()
          : openCases.isNotEmpty
              ? ListView.builder(
                  itemCount: openCases.length,
                  itemBuilder: (context, index) {
                    final data = openCases[index];
                    return FutureBuilder(
                      future: fetchClient(data['client_id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final client = snapshot.data;
                          return OpenCasesCard(
                              name: client?['name'],
                              subject: data['subject'],
                              caseClosed: data['case_closed'],
                              onTap: () => {
                                Navigator.pushNamed(context, '/open_case', arguments: {'request_id':data['id'].toString(), 'client_id': data['client_id']})
                              });
                        }
                      },
                    );
                  },
                )
              : const Center(
                  child: Text("No cases found."),
                ),
    );
  }
}
