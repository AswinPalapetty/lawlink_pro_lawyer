import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String optionHeading;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.icon,
    required this.optionHeading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  height: 150,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(
                  icon,
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                optionHeading,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }
}