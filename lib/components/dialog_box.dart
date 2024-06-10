import 'package:flutter/material.dart';
import 'package:gymbro_app/components/app_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter task name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //cancel button
                AppButton(
                    text: 'Cancel',
                    onPressed: onCancel,
                    color: Colors.yellow[200]),
                //gap
                const SizedBox(width: 5),
                //save button
                AppButton(text: 'Save', onPressed: onSave),
              ],
            )
          ],
        ),
      ),
    );
  }
}
