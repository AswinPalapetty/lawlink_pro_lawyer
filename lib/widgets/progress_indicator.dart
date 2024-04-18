import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 10, 63, 105)),
        ),
      ),
    );
  }
}
