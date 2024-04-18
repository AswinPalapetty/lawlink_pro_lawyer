import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/custom_text_form_field.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _profileFormKey = GlobalKey<FormState>();
  late Map<String, dynamic> user;
  bool isLoading = true;
  String? registration,
      education,
      callCharge,
      sittingCharge,
      location,
      praticeAreas,
      experience,
      courts,
      description,
      casesAppeared,
      casesWon;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    final sessionData = await SessionManagement.getUserData();
    final res = await Supabase.instance.client.from('lawyers').select().eq('user_id', sessionData['userId']!).single();
    setState(() {
      user = res;
      _imageUrl = res['image'];
      registration = res['registration_no'];
      education = res['education']?.join(', ');
      callCharge = res['call_charge'];
      sittingCharge = res['sitting_charge'];
      location = res['location'];
      praticeAreas = res['practice_areas']?.join(', ');
      experience = res['experience'];
      courts = res['courts'];
      description = res['description'];
      casesAppeared = res['no_of_cases_appeared'];
      casesWon = res['cases_won'];
      isLoading = false;
    });
  }

  Future<String?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final imageExtension = image.path.split('.').last.toLowerCase();
    final imageBytes = await image.readAsBytes();
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final imagePath = '/$userId/profile';
    await Supabase.instance.client.storage
        .from('lawyer_profile')
        .uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$imageExtension',
          ),
        )
        .then((value) => print(
            "Successfully inserted the image into bucket. result == $value"))
        .catchError((error) => print("An error occured. Error == $error"));
    String imageUrl = Supabase.instance.client.storage
        .from('lawyer_profile')
        .getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    return imageUrl;
  }

  onUpload(String imageUrl) async {
    setState(() {
      _imageUrl = imageUrl;
    });
    await Supabase.instance.client
        .from('lawyers')
        .update({'image': imageUrl}).eq('user_id', user['user_id']!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: null,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 4, top: 3),
              child: IconButton(
                  onPressed: () {
                    Supabase.instance.client.auth.signOut();
                    removeUserData();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                  iconSize: 30),
            )
          ],
        ),
        body: isLoading
            ? const CustomProgressIndicator()
            : SingleChildScrollView(
                child: Form(
                  key: _profileFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: _imageUrl != null
                            ? Image.network(
                                _imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Text('No Image'),
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          final imageUrl = await selectImage();
                          imageUrl != null ? onUpload(imageUrl) : '';
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 37, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Upload',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  labelText: 'First Name',
                                  initialValue:
                                      user['name'].toString().split(' ')[0],
                                  enabled: false,
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  labelText: 'Last Name',
                                  initialValue:
                                      user['name'].toString().split(' ')[1],
                                  enabled: false,
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: const [AutofillHints.name],
                            obscureText: false,
                            labelText: 'Phone Number',
                            initialValue: user['phone'],
                            enabled: false,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: const [AutofillHints.name],
                            obscureText: false,
                            labelText: 'Email ID',
                            initialValue: user['email'],
                            enabled: false,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText: 'Enter your Registration No',
                            labelText: 'Registration No',
                            initialValue: user['registration_no'],
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                registration = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText:
                                'Enter your qualifications from highest to lowest, separated by commas',
                            labelText: 'Education',
                            initialValue: user['education']?.join(', ') ?? '',
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                education = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText: 'Enter your call charge',
                            labelText: 'Call Charge',
                            initialValue: user['call_charge'],
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                callCharge = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText: 'Enter your court sitting charge',
                            labelText: 'Sitting Charge',
                            initialValue: user['sitting_charge'],
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                sittingCharge = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText: 'Enter your location',
                            labelText: 'Location',
                            initialValue: user['location'],
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                location = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText:
                                'Enter your practice areas, separated by commas',
                            labelText: 'Practice Areas',
                            initialValue: user['practice_areas']?.join(', ') ?? '',
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                praticeAreas = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText: 'Enter your experience(in years)',
                            labelText: 'Experience',
                            initialValue: user['experience'],
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                experience = value;
                              });
                            },
                          )),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: null,
                                  obscureText: false,
                                  hintText: 'No. of cases appeared',
                                  labelText: 'Cases Apppeared',
                                  initialValue: user['no_of_cases_appeared'],
                                  validator: (value) => defaultValidator(value),
                                  onSaved: (value) {
                                    setState(() {
                                      casesAppeared = value;
                                    });
                                  },
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: null,
                                  obscureText: false,
                                  hintText: 'No. of cases won',
                                  labelText: 'Cases Won',
                                  initialValue: user['cases_won'],
                                  validator: (value) => defaultValidator(value),
                                  onSaved: (value) {
                                    setState(() {
                                      casesWon = value;
                                    });
                                  },
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: false,
                            hintText: 'Enter the courts you have appeared',
                            labelText: 'Courts',
                            initialValue: user['courts'],
                            validator: (value) => defaultValidator(value),
                            onSaved: (value) {
                              setState(() {
                                courts = value;
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          autocorrect: true,
                          initialValue: user['description'],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              hintText: "write about yourself",
                              labelText: 'Description',
                              alignLabelWithHint: true),
                          minLines: 3,
                          maxLines: 10,
                          validator: (value) => defaultValidator(value),
                          onSaved: (value) {
                            setState(() {
                              description = value;
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
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onFormSubmit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 3, 37, 65),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0)),
                                child: const Text('Update',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ));
  }

  defaultValidator(value) {
    if (value == '') {
      return "This field is required.";
    }
    return null;
  }

  onFormSubmit() async {
    if (_profileFormKey.currentState!.validate()) {
      _profileFormKey.currentState!.save();

      try {
        final profileDetails = {
          'education': education?.toString().split(','),
          'practice_areas': praticeAreas.toString().split(','),
          'registration_no': registration,
          'call_charge': callCharge,
          'sitting_charge': sittingCharge,
          'location': location,
          'experience': experience,
          'courts': courts,
          'profile_completed': true,
          'email': user['email'],
          'description': description,
          'no_of_cases_appeared': casesAppeared,
          'cases_won': casesWon
        };
        final resp = await Supabase.instance.client
            .from('lawyers')
            .update(profileDetails)
            .eq('user_id', user['user_id']!);
        print('Insertion successful: $resp');
        final snackBar = SnackBar(
            content: const Text('profile updation successfull.'),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                // emailController.clear();
                // passwordController.clear();
              },
            ));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } catch (e) {
        print('insertion error =======  $e');
        final snackBar = SnackBar(
            content: const Text('profile updation failed.'),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                // emailController.clear();
                // passwordController.clear();
              },
            ));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  removeUserData() async {
    await SessionManagement.clearUserData();
  }
}
