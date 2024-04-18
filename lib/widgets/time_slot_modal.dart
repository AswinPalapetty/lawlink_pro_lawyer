import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeSlotModal extends StatefulWidget {
  final String lawyerId; // Make initialValue a required parameter

  const TimeSlotModal({required this.lawyerId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimeSlotModalState createState() => _TimeSlotModalState();
}

class _TimeSlotModalState extends State<TimeSlotModal> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExistingSlots();
  }

  void fetchExistingSlots() async {
    try {
      final response = await Supabase.instance.client
          .from('time_slots')
          .select('slots')
          .eq('lawyer_id', widget.lawyerId);

      if (response.isNotEmpty) {
        final slots = response[0]['slots'].join(',');
        controller.text = slots;
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching existing slots: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: isLoading
          ? const CustomProgressIndicator()
          : Container(
              padding: const EdgeInsets.all(16),
              width: 450,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Time Slots',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller, // Set the controller
                    decoration: InputDecoration(
                      hintText: 'Enter time slots separated by commas',
                      hintStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Example: 10am, 11am, 12pm, etc.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          createTimeSlot(context,
                              controller.text); // Pass value to function
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 37, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void createTimeSlot(BuildContext context, String timeSlots) async {
    FocusScope.of(context).unfocus();
    if (timeSlots == '') {
      snackBar(context, 'Please provide some time slots.');
      return;
    }
    final slots = timeSlots.toString().split(',');
    try {
      final existingRow = await Supabase.instance.client
          .from('time_slots')
          .select()
          .eq('lawyer_id', widget.lawyerId);
      print(existingRow);
      if (existingRow.isEmpty) {
        try {
          await Supabase.instance.client
              .from('time_slots')
              .insert({'slots': slots, 'lawyer_id': widget.lawyerId});
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          snackBar(context, 'Time slots created successfully.');
        } catch (error) {
          print("error ==== $error");
          // ignore: use_build_context_synchronously
          snackBar(context, 'Failed to create time slots.');
        }
      } else {
        try {
          await Supabase.instance.client
              .from('time_slots')
              .update({'slots': slots}).eq('lawyer_id', widget.lawyerId);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          snackBar(context, 'Time slots updated successfully.');
        } catch (error) {
          print("error ==== $error");
          // ignore: use_build_context_synchronously
          snackBar(context, 'Failed to update time slots.');
        }
      }
    } catch (error) {
      print("error ==== $error");
      // ignore: use_build_context_synchronously
      snackBar(context, 'Failed to create time slots.');
    }
  }

  void snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
