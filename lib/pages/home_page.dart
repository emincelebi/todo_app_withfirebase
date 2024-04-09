import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/pages/todo_dialog.dart';
import 'package:todo_app/service/todo_databse_service.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder<List<ToDoModel>>(
            stream: ToDoDatabaseService().listToDo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              List<ToDoModel>? todo = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My To Do",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: todo!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(todo[index].uid),
                            background: Container(
                                alignment: Alignment.centerLeft,
                                color: Colors.red,
                                child: const Icon(Icons.delete)),
                            onDismissed: (direction) async {
                              await ToDoDatabaseService()
                                  .deleteTask(todo[index].uid);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                child: ListTile(
                                  onTap: () async {
                                    bool newCheck = !todo[index].isCheck;
                                    await ToDoDatabaseService()
                                        .updateTask(todo[index].uid, newCheck);
                                  },
                                  title: Text(
                                    todo[index].message,
                                    style: TextStyle(
                                      fontSize: 23,
                                      decoration: todo[index].isCheck
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[100],
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) =>
                  ToDoDialog(controller: todoTitleController)));
        },
        child: Icon(
          Icons.add,
          color: Colors.blue[200],
        ),
      ),
    );
  }
}
