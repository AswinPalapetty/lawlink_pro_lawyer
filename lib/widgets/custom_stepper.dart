import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final List<StepData> steps;

  const CustomStepper({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.map((step) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      step.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: step.onDelete,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              Text(step.message),
              Text(step.otherStatus),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: step.buttons.map((button) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 172, 170, 170),
                      ),
                      onPressed: button.onPressed,
                      child: Row(
                        children: [
                          Icon(button.icon, color: Colors.black),
                          Text(
                            button.label,
                            style: const TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Divider(), // Add a divider between steps
            ],
          ),
        );
      }).toList(),
    );
  }
}

class StepData {
  final String title;
  final String message, otherStatus;
  final List<ButtonData> buttons;
  final VoidCallback onDelete;

  const StepData({
    required this.otherStatus,
    required this.onDelete,
    required this.title,
    required this.message,
    required this.buttons,
  });
}

class ButtonData {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ButtonData({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}
