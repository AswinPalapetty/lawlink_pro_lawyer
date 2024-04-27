import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/home_button.dart';
import 'package:lawlink_lawyer/widgets/home_scaffold.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                child: Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                            text: "LawLink Pro\n",
                            style: TextStyle(
                                fontSize: 45.0, fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: "(For Lawyer)\n",
                            style: TextStyle(
                                fontSize: 22.0, height: 1.3, fontStyle: FontStyle.italic)),
                        TextSpan(
                            text:
                                "Revolutionizing Client-Lawyer Collaboration with Seamless Communication",
                            style: TextStyle(fontSize: 17, height: 1.6))
                      ])),
                ),
              )),
          const Flexible(
              flex: 1,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height:
                          56, // Adjust this value according to your button height
                      child: Row(
                        children: [
                          Expanded(
                            child: HomeButton(
                              backgroundClr: Colors.white,
                              buttonText: 'Login',
                              route: '/login',
                              textColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: HomeButton(
                              backgroundClr: Color.fromARGB(255, 3, 37, 65),
                              buttonText: 'SignUp',
                              route: '/signup',
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
