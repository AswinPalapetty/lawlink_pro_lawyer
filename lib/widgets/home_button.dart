import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key, this.route, this.backgroundClr, this.buttonText, this.textColor});

  final String? route;
  final Color? backgroundClr;
  final String? buttonText;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route!);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundClr!, //Color.fromARGB(255, 3, 37, 65),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.0), // Adjust the radius as needed
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0)),
      child: Text(buttonText!,
          style: TextStyle(color: textColor!, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
