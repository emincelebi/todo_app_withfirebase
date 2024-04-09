import 'package:flutter/material.dart';
import 'package:todo_app/service/todo_databse_service.dart';

class ToDoDialog extends StatelessWidget {
  const ToDoDialog({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Text(
            "Add Todo",
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel, color: Colors.white))
        ],
      ),
      children: [
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          autofocus: true,
          decoration: const InputDecoration(
              hintText: "eg.Flutter",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await ToDoDatabaseService()
                      .createNewTodo(controller.text.trim());
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                controller.clear();
              },
              child: const Text("Add")),
        )
      ],
    );
  }
}
