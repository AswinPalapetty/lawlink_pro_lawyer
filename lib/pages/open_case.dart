import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:lawlink_lawyer/widgets/custom_stepper.dart';
import 'package:lawlink_lawyer/widgets/lawyer_home_scaffold.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OpenCase extends StatefulWidget {
  const OpenCase({super.key});

  @override
  State<OpenCase> createState() => _OpenCaseState();
}

class _OpenCaseState extends State<OpenCase> {
  late String caseRequestId, clientId;
  late PostgrestList caseUpdates;
  late Map<String, dynamic> clientDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchCaseEvents();
    });
  }

  Future<void> fetchCaseEvents() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      clientId = args['client_id'];
      caseRequestId = args['request_id'];
    });
    clientDetails = await Supabase.instance.client
        .from('clients')
        .select()
        .eq('user_id', clientId)
        .single();
    caseUpdates = await Supabase.instance.client
        .from('case_proceedings')
        .select()
        .eq('request_id', int.parse(caseRequestId))
        .order('created_at');
    setState(() {
      isLoading = false;
    }); // Trigger a rebuild after fetching data
  }

  void onDelete(int id) async {
    setState(() {
      isLoading = true;
    });
    await Supabase.instance.client
        .from('case_proceedings')
        .delete()
        .eq('id', id)
        .then((value) {
      fetchCaseEvents();
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
          content: const Text('Case status removed.'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((error) {
      print("Error ==== $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return LawyerHomeScaffold(
      child: isLoading
          ? const CustomProgressIndicator()
          : SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Case Proceedings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client Name: ${clientDetails['name']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Phone No: ${clientDetails['phone']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/add_status',
                                    arguments: {
                                      'request_id': caseRequestId,
                                      'client_id': clientId,
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 3, 37, 65)),
                              child: const Text(
                                'Add status',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/chat_page',
                                    arguments: {
                                      'clientId': clientId,
                                      'clientName': clientDetails['name']
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 3, 37, 65)),
                              child: const Text(
                                'Chat with client',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomStepper(
                    steps: caseUpdates.map((update) {
                      return StepData(
                        otherStatus: update['is_file_download'] &&
                                update['download_file'] == null
                            ? "\nThe file upload request has been generated but has not been completed by the client."
                            : (update['is_payment_request'] &&
                                    update['amount_paid'] == false
                                ? '\nThe client has been requested Rs.${update['amount']}, but the payment has not been made.'
                                : (update['is_payment_request'] &&
                                        update['amount_paid']
                                    ? "\nThe client has paid Rs.${update['amount']}."
                                    : (update['is_file_upload'] &&
                                            update['uploaded_file'] != null
                                        ? '\nA file has been successfully uploaded.'
                                        : ''))),
                        onDelete: () => {onDelete(update['id'])},
                        title: update['title'] ?? '',
                        message: update['message'] ?? '',
                        buttons: [
                          if (update['download_file'] != null) ...[
                            ButtonData(
                              label: 'Download',
                              icon: Icons.download,
                              onPressed: () async {
                                FileDownloader.downloadFile(
                                  url: update['download_file'],
                                  onDownloadError: (errorMessage) {
                                    print("download error : $errorMessage");
                                  },
                                  onDownloadCompleted: (path) {
                                    final File file = File(path);
                                    print('file : $file');
                                  },
                                );
                              },
                            ),
                          ]
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
          ),
    );
  }
}
