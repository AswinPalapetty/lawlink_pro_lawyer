import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/extensions.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/custom_text_form_field.dart';
import 'package:lawlink_lawyer/widgets/home_scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:password_hash_plus/password_hash_plus.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formSignUpKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? firstName, lastName, email, password, cpassword, phone;
  final supabase = Supabase.instance.client;
  var generator = PBKDF2();
  var salt = Salt.generateAsBase64String(10);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        child: Column(
      children: [
        const Expanded(
            flex: 0,
            child: SizedBox(
              height: 10,
            )),
        Expanded(
          flex: 8,
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "SignUp",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 73, 129)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  hintText: 'Enter First Name',
                                  labelText: 'First Name',
                                  validator: (value) =>
                                      firstNameValidator(value),
                                  onSaved: (value) {
                                    setState(() {
                                      firstName = value;
                                    });
                                  },
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextFormField(
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  hintText: 'Enter Last Name',
                                  labelText: 'Last Name',
                                  validator: (value) =>
                                      lastNameValidator(value),
                                  onSaved: (value) {
                                    setState(() {
                                      lastName = value;
                                    });
                                  },
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            obscureText: false,
                            hintText: 'Enter Phone Number',
                            labelText: 'Phone',
                            validator: (value) {
                              if (!value!.isValidPhone) {
                                return "Enter a valid Phone number.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                phone = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: const [AutofillHints.email],
                            obscureText: false,
                            controller: emailController,
                            hintText: 'Enter Email ID',
                            labelText: 'Email',
                            validator: (value) {
                              if (!value!.isValidEmail) {
                                return "Enter a valid Email.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: true,
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            validator: (value) {
                              if (!value!.isValidPassword) {
                                return "Enter a valid Password.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            controller: passwordController,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextFormField(
                            autofillHints: null,
                            obscureText: true,
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                            validator: (value) {
                              if (!value!.isValidPassword) {
                                return "Enter a valid Password.";
                              } else if (value != passwordController.text) {
                                return "Password doesn't match.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                cpassword = value;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onSignupSubmit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 3, 37, 65),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0)),
                                child: const Text('Signup',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ))),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 90, 159),
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  onSignupSubmit() async {
    if (_formSignUpKey.currentState!.validate()) {
      _formSignUpKey.currentState!.save();

      try {
        final AuthResponse res =
            await supabase.auth.signUp(email: '$email', password: '$password');

        try {
          final userDetails = {
            'user_id': res.user!.id,
            'name': '$firstName $lastName',
            'phone': phone
          };

          final resp = await supabase.from('lawyers').upsert(userDetails);
          await SessionManagement.storeUserData({
            'userId': res.user!.id,
            'email': email,
            'name': '$firstName $lastName',
            'phone': phone
          });

          print('Insertion successful: $resp');

          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(context, '/complete_profile', (route) => false);
        } catch (e) {
          print('insertion error =======  $e');
          await supabase.auth.admin.deleteUser(res.user!.id);
          final snackBar = SnackBar(
              content: const Text('Signup failed. please try again.'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                  emailController.clear();
                  passwordController.clear();
                },
              ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        print('auth error =======  $e');
        final snackBar = SnackBar(
            content: const Text('email already exists.'),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                emailController.clear();
              },
            ));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      // } else {
      //   final snackBar = SnackBar(
      //       content: const Text('email already exists.'),
      //       action: SnackBarAction(
      //         label: 'Close',
      //         onPressed: () {
      //           emailController.clear();
      //         },
      //       ));
      //   // ignore: use_build_context_synchronously
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
    } else {}
  }

  firstNameValidator(value) {
    if (value == '') {
      return "Enter First Name.";
    }
    return null;
  }

  lastNameValidator(value) {
    if (value == '') {
      return "Enter Last Name.";
    }
    return null;
  }
}
