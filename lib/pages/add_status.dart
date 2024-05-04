import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/custom_text_form_field.dart';
import 'package:lawlink_lawyer/widgets/file_upload_form_field.dart';
import 'package:lawlink_lawyer/widgets/home_scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddStatus extends StatefulWidget {
  const AddStatus({super.key});

  @override
  State<AddStatus> createState() => _AddStatusState();
}

class _AddStatusState extends State<AddStatus> {
  final _formAddStatusKey = GlobalKey<FormState>();
  late Map<String, String> userData;
  String? title,
      message,
      amount,
      selectedValue,
      clientId,
      caseRequestId,
      fileUrl,
      extension;
  bool? isFileUploaded = false,
      isFileDownload = false,
      isPaymentRequest = false,
      amountPaid;

  final Map<String, String> contentTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'tiff': 'image/tiff',
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  };

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDetails();
    });
  }

  Future<void> fetchDetails() async {
    userData = await SessionManagement.getUserData();
    final args =
        // ignore: use_build_context_synchronously
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      clientId = args['client_id'];
      caseRequestId = args['request_id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 0,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formAddStatusKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Add Status",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 4, 73, 129),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextFormField(
                          autofillHints: const [AutofillHints.name],
                          obscureText: false,
                          hintText: 'Title',
                          labelText: 'Title',
                          validator: (value) => defaultValueValidator(value),
                          onSaved: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          autocorrect: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            hintText: "Give a description...",
                            labelText: "Description",
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                          onSaved: (value) {
                            setState(() {
                              message = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Select',
                          ),
                          validator: (value) => defaultValueValidator(value),
                          value: selectedValue,
                          onChanged: (newValue) {
                            if(newValue == 'download'){
                              setState(() {
                                selectedValue = newValue;
                                isFileDownload = true;
                              });
                            }
                            else{
                              setState(() {
                                selectedValue = newValue;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'upload',
                              child: Text('Upload a file'),
                            ),
                            DropdownMenuItem(
                              value: 'download',
                              child: Text('Request client to upload a file'),
                            ),
                            DropdownMenuItem(
                              value: 'amount',
                              child: Text('Request fees'),
                            ),
                            DropdownMenuItem(
                              value: 'not applicable',
                              child: Text('Not Applicable'),
                            ),
                          ],
                        ),
                      ),
                      if (selectedValue == 'upload')
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FileUploadFormField(
                            hintText: 'Select file to upload',
                            labelText: 'Upload File',
                            onFilePicked: (file) async {
                              extension =
                                  file.path.split('/').last.split('.').last;
                              isFileUploaded = true;
                              final randomNumber = Random().nextInt(10000).toString();
                              final fileBytes = await file.readAsBytes();
                              final filePath = '/$caseRequestId/file_$randomNumber';
                              await Supabase.instance.client.storage
                                  .from('case_files')
                                  .uploadBinary(
                                    filePath,
                                    fileBytes,
                                    fileOptions: FileOptions(
                                      upsert: true,
                                      contentType: contentTypes[extension],
                                    ),
                                  )
                                  .then((value) => {
                                        print("Successfully inserted the file into bucket. result == $value"),
                                        fileUrl = Supabase
                                            .instance.client.storage
                                            .from('case_files')
                                            .getPublicUrl(filePath),
                                        fileUrl = Uri.parse(fileUrl!).replace(
                                            queryParameters: {
                                              't': DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString()
                                            }).toString()
                                      })
                                  // ignore: invalid_return_type_for_catch_error
                                  .catchError((error) => print("An error occured. Error == $error"));
                              print('file url ==== $fileUrl');
                            },
                          ),
                        ),
                      if (selectedValue == 'amount')
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            obscureText: false,
                            hintText: 'Enter amount',
                            labelText: 'Amount',
                            validator: (value) => defaultValueValidator(value),
                            onSaved: (value) {
                              setState(() {
                                isPaymentRequest = true;
                                amount = value;
                              });
                            },
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 110,
                          child: ElevatedButton(
                            onPressed: onAddStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 3, 37, 65),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onAddStatus() async {
    if (_formAddStatusKey.currentState!.validate()) {
      _formAddStatusKey.currentState!.save();

      try {
        final formDetails = {
          'title': title ?? '',
          'message': message ?? '',
          'amount': amount,
          'request_id': caseRequestId,
          'client_id': clientId,
          'lawyer_id': userData['userId'],
          'is_file_upload': isFileUploaded,
          'is_file_download': isFileDownload,
          'is_payment_request': (amount == null ? false : true),
          'amount_paid': (amount == null ? null : false),
          'uploaded_file': fileUrl
        };

        await Supabase.instance.client
            .from('case_proceedings')
            .upsert(formDetails)
            .then((value) {
          final snackBar = SnackBar(
              content: const Text('New status added.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushNamed(context, '/open_case', arguments: {'request_id':caseRequestId.toString(), 'client_id': clientId});
        }).catchError((error) {
          print("error === $error");
          final snackBar = SnackBar(
              content: const Text('Error occured.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } catch (error) {
        print("error === $error");
      }
    } else {
      // Form validation failed
    }
  }

  String? defaultValueValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required.";
    }
    return null;
  }
}
