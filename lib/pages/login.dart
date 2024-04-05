import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/utils/extensions.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:lawlink_lawyer/widgets/custom_text_form_field.dart';
import 'package:lawlink_lawyer/widgets/home_scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formLoginKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      child: Column(
        children: [
          const Expanded(
              flex: 3,
              child: SizedBox(
                height: 10,
              )),
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                  child: Form(
                      key: _formLoginKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 4, 73, 129),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CustomTextFormField(
                                autofillHints: const [AutofillHints.email],
                                obscureText: false,
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
                              padding: const EdgeInsets.all(15.0),
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
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: onLoginSubmit,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 37, 65),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0)),
                                    child: const Text('Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ))),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 7, 90, 159),
                                  decoration: TextDecoration.underline,
                                  fontSize: 16),
                            ),
                          )
                        ],
                      ))),
            ),
          )
        ],
      ),
    );
  }

  onLoginSubmit() async {
    if (_formLoginKey.currentState!.validate()) {
      _formLoginKey.currentState!.save();
      try {
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: '$email',
          password: '$password',
        );
        final User? user = res.user;
        PostgrestList? userData;
        if (user != null) {
          try {
            userData =
                await supabase.from('lawyers').select().eq('user_id', user.id);
          } catch (e) {
            print("error ====== $e");
            // ignore: use_build_context_synchronously
            _showSnackbar(context, 'Login failed. Please try again.');
          }
          final sessionUserData = {
            'name': userData?[0]['name'] ?? '',
            'phone': userData?[0]['phone'] ?? '',
            'email': user.email,
            'userId': user.id,
          };
          await SessionManagement.storeUserData(sessionUserData);
        }
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } catch (e) {
        print("Login Error ==== $e");
        // ignore: use_build_context_synchronously
        _showSnackbar(context, 'Incorrect email or password.');
      }
    } else {}
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
