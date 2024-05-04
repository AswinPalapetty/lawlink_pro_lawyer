import 'package:flutter/material.dart';

class OpenCasesCard extends StatelessWidget {
  final String name;
  final String subject;
  final VoidCallback? onTap;
  final bool caseClosed;

  const OpenCasesCard({
    super.key,
    required this.name,
    required this.subject,
    this.onTap,
    required this.caseClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  "Client: $name",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: "Subject: $subject",
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(text: '\n'), // Add a new line
                      TextSpan(
                        text: caseClosed ? "Case Closed" : "",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(
                    Icons.arrow_forward_ios), // Add your desired icon here
              ),
            ),
          ),
        ),
      ),
    );
  }
}
